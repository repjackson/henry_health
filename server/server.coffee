
Meteor.users.allow
    insert: (userId, doc, fields, modifier) ->
        true
    update: (userId, doc, fields, modifier) ->
        true
    remove: (userId, doc, fields, modifier) ->
        true
        # # console.log 'user ' + userId + 'wants to modify doc' + doc._id
        # if userId and doc._id == userId
        #     # console.log 'user allowed to modify own account'
        #     true

Cloudinary.config
    cloud_name: 'facet'
    api_key: Meteor.settings.cloudinary_key
    api_secret: Meteor.settings.cloudinary_secret


Meteor.publish 'featured_posts', ->
    Docs.find
        type: 'post'
        featured: true

Meteor.publish 'type', (type)->
    Docs.find
        type: type


Meteor.publish 'facet_doc', (tags)->
    split_array = tags.split ','
    Docs.find
        tags: split_array

Meteor.publish 'users', ()->
    Meteor.users.find()

Meteor.publish 'me', ()->
    Meteor.users.find Meteor.userId()

Meteor.methods
    set_delta_facets: (type)->
        my_delta = Docs.findOne
            type:'delta'
            author_id:Meteor.userId()

        schema = Docs.findOne
            type:'schema'
            slug:type

        if 'dev' in Meteor.user().roles
            schema_bricks = Docs.find({
                type:'brick'
                parent_id:schema._id
                # view_roles: $in:Meteor.user().roles
                # field:$nin:['text','single_doc','multi_doc','boolean']
            }, sort:rank:1).fetch()
        else
            schema_bricks = Docs.find({
                type:'brick'
                parent_id:schema._id
                view_roles: $in:Meteor.user().roles
                # field:$nin:['text','single_doc','multi_doc','boolean']
            }, sort:rank:1).fetch()

        # console.log 'schema bricks', schema_bricks

        facets = []
        for brick in schema_bricks
            # console.log brick
            unless brick.field in ['textarea','image','youtube','html']
                if _.intersection(Meteor.user().roles,brick.faceted_roles).length > 0
                    # console.log 'intersection', _.intersection(Meteor.user().roles,brick.faceted_roles)
                    # console.log 'faceted roles',brick.faceted_roles
                    # console.log 'brick',brick.label
                    facet = {
                        key:brick.key
                        label:brick.label
                        icon:brick.icon
                        filters:[]
                        res:[]
                    }
                    facets.push facet

        timestamp_tags_facet = {
            key:'timestamp_tags'
            label:'Created'
            icon:'clock'
            filters:[]
            res:[]
        }
        facets.push timestamp_tags_facet

        Docs.update my_delta._id,
            $set:
                doc_type:type
                # user_id:user_id
                facets: facets

        # console.log 'delta after set facets', Docs.findOne({type:'delta'})
        Meteor.call 'fum', my_delta._id, tribe
