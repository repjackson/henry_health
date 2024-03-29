Meteor.methods
    set_facets: (type_slug)->
        delta = Docs.findOne
            type:'delta'
            _author_id:Meteor.userId()
        type = Docs.findOne
            type:'type'
            slug:type_slug
        # console.log type
        fields =
            Docs.find
                type:'field'
                parent_id:type._id

        Docs.update delta._id,
            $set:type_filter:type_slug

        Docs.update delta._id,
            $set:facets:[
                {
                    key:'_timestamp_tags'
                    filters:[]
                    res:[]
                }
            ]
        for field in fields.fetch()
            # console.log field.field_type
            # console.log field.key
            unless field.field_type in ['textarea','image','youtube','html']
                unless field.key in ['slug','icon']
                # console.log 'adding field to delta', field.key
                    Docs.update delta._id,
                        $addToSet:
                            facets: {
                                key:field.key
                                filters:[]
                                res:[]
                            }
        Meteor.call 'fum', delta._id


    fum: (delta_id)->
        # console.log 'running fum', delta_id
        delta = Docs.findOne delta_id
        # console.log delta
        type = Docs.findOne
            type:'type'
            slug:delta.type_filter
        # console.log type
        fields =
            Docs.find
                type:'field'
                parent_id:type._id
        # console.log 'fields', fields.fetch()
        # console.log 'delta', delta
        built_query = { type:delta.type_filter }

        for facet in delta.facets
            # console.log 'this facet', facet.key
            if facet.filters.length > 0
                built_query["#{facet.key}"] = $all: facet.filters

        total = Docs.find(built_query).count()
        # console.log 'built query', built_query

        # response
        for facet in delta.facets
            values = []
            local_return = []

            # agg_res = Meteor.call 'agg', built_query, facet.key, type.collection
            agg_res = Meteor.call 'agg', built_query, facet.key

            if agg_res
                Docs.update { _id:delta._id, 'facets.key':facet.key},
                    { $set: 'facets.$.res': agg_res }

        modifier =
            {
                fields:_id:1
                limit:20
                sort:_timestamp:-1
            }

        # results_cursor =
        #     Docs.find( built_query, modifier )

        if type and type.collection and type.collection is 'users'
            results_cursor = Meteor.users.find(built_query, modifier)
            # else
            #     results_cursor = global["#{type.collection}"].find(built_query, modifier)
        else
            results_cursor = Docs.find built_query, modifier


        # if total is 1
        #     result_ids = results_cursor.fetch()
        # else
        #     result_ids = []
        result_ids = results_cursor.fetch()

        # console.log 'result ids', result_ids
        # console.log 'delta', delta
        # console.log Meteor.userId()

        Docs.update {_id:delta._id},
            {$set:
                total: total
                result_ids:result_ids
            }, ->
        return true


        # delta = Docs.findOne delta_id
        # console.log 'delta', delta

    agg: (query, key, collection)->
        limit=42
        # console.log 'agg query', query
        # console.log 'agg key', key
        # console.log 'agg collection', collection
        options = { explain:false }
        pipe =  [
            { $match: query }
            { $project: "#{key}": 1 }
            { $unwind: "$#{key}" }
            { $group: _id: "$#{key}", count: $sum: 1 }
            { $sort: count: -1, _id: 1 }
            { $limit: limit }
            { $project: _id: 0, name: '$_id', count: 1 }
        ]
        if pipe
            if collection and collection is 'users'
                agg = Meteor.users.rawCollection().aggregate(pipe,options)
            else
                agg = global['Docs'].rawCollection().aggregate(pipe,options)
            # else
            res = {}
            # console.log 'res', res
            if agg
                agg.toArray()
        else
            return null
