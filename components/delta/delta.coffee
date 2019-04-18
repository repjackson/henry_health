Router.route '/t/:type_slug', -> @render 'delta'
Router.route '/t/:type_slug/:doc_id/edit', -> @render 'type_doc_edit'
Router.route '/t/:type_slug/:doc_id/view', -> @render 'type_doc_view'
Router.route '/types', -> @render 'types'
Router.route '/type/edit/:doc_id', -> @render 'type_edit'

Router.route '/delta', -> @render 'delta'




Meteor.methods
    add_facet_filter: (delta_id, key, filter)->
        # if key is '_keys'
        #     new_facet_ob = {
        #         key:filter
        #         filters:[]
        #         res:[]
        #     }
        #     Docs.update { _id:delta_id },
        #         $addToSet: facets: new_facet_ob
        Docs.update { _id:delta_id, "facets.key":key},
            $addToSet: "facets.$.filters": filter

        Meteor.call 'fum', delta_id, (err,res)->


    remove_facet_filter: (delta_id, key, filter)->
        # if key is '_keys'
        #     Docs.update { _id:delta_id },
        #         $pull:facets: {key:filter}
        Docs.update { _id:delta_id, "facets.key":key},
            $pull: "facets.$.filters": filter
        Meteor.call 'fum', delta_id, (err,res)->


if Meteor.isClient
    Template.delta.onCreated ->
        # @autorun -> Meteor.subscribe 'type', Router.current().params.type_slug
        # @autorun -> Meteor.subscribe 'type', 'type'
        # @autorun -> Meteor.subscribe 'tags', selected_tags.array(), Router.current().params.type_slug
        # @autorun -> Meteor.subscribe 'docs', selected_tags.array(), Router.current().params.type_slug
        @autorun -> Meteor.subscribe 'type_from_slug', Router.current().params.type_slug
        @autorun -> Meteor.subscribe 'type_fields_from_slug', Router.current().params.type_slug
        # @autorun -> Meteor.subscribe 'deltas', Router.current().params.type_slug
        @autorun -> Meteor.subscribe 'my_delta'
    Template.registerHelper 'view_template', ->
        # console.log @
        "#{@field_type}_view"

    Template.registerHelper 'edit_template', ->
        "#{@field_type}_edit"

    Template.registerHelper 'is_type', -> @type is 'type'

    Template.registerHelper 'field_value', () ->
        # console.log @
        parent = Template.parentData()
        parent2 = Template.parentData(2)
        parent3 = Template.parentData(3)
        parent4 = Template.parentData(4)
        parent5 = Template.parentData(5)
        parent6 = Template.parentData(6)

        # console.log parent
        # console.log parent2
        # console.log parent3
        # console.log parent4
        # console.log parent5
        # console.log parent6

        if @direct
            parent = Template.parentData()
        else
            parent = Template.parentData(5)
        parent["#{@key}"]

    Template.registerHelper 'fields', () ->
        type = Docs.findOne
            type:'type'
            slug:@type
        # console.log type
        Docs.find
            type:'field'
            parent_id:type._id

    Template.delta.helpers
        selected_tags: -> selected_tags.list()

        current_delta: ->
            Docs.findOne
                type:'delta'
                _author_id:Meteor.userId()

        global_tags: ->
            doc_count = Docs.find().count()
            if 0 < doc_count < 3 then Tags.find { count: $lt: doc_count } else Tags.find()

        single_doc: ->
            delta = Docs.findOne type:'delta'
            count = delta.result_ids.length
            if count is 1 then true else false


    Template.delta.events
        'click .create_delta': (e,t)->
            Docs.insert
                type:'delta'
                type_filter: Router.current().params.type_slug

        'click .print_delta': (e,t)->
            delta = Docs.findOne type:'delta'
            console.log delta

        'click .reset': ->
            type_slug =  Router.current().params.type_slug
            Session.set 'loading', true
            Meteor.call 'set_facets', type_slug, ->
                Session.set 'loading', false

        'click .delete_delta': (e,t)->
            delta = Docs.findOne type:'delta'
            if delta
                if confirm "delete  #{delta._id}?"
                    Docs.remove delta._id

        'click .add_type_doc': ->
            new_doc_id = Docs.insert
                type:Router.current().params.type_slug
            Router.go "/t/#{Router.current().params.type_slug}/#{new_doc_id}/edit"


        'click .edit_type': ->
            type = Docs.findOne
                type:'type'
                slug: Router.current().params.type_slug
            Router.go "/type/edit/#{type._id}"

        # 'click .page_up': (e,t)->
        #     delta = Docs.findOne type:'delta'
        #     Docs.update delta._id,
        #         $inc: current_page:1
        #     Session.set 'is_calculating', true
        #     Meteor.call 'fo', (err,res)->
        #         if err then console.log err
        #         else
        #             Session.set 'is_calculating', false
        #
        # 'click .page_down': (e,t)->
        #     delta = Docs.findOne type:'delta'
        #     Docs.update delta._id,
        #         $inc: current_page:-1
        #     Session.set 'is_calculating', true
        #     Meteor.call 'fo', (err,res)->
        #         if err then console.log err
        #         else
        #             Session.set 'is_calculating', false

        # 'click .select_tag': -> selected_tags.push @name
        # 'click .unselect_tag': -> selected_tags.remove @valueOf()
        # 'click #clear_tags': -> selected_tags.clear()
        #
        # 'keyup #search': (e)->
            # switch e.which
            #     when 13
            #         if e.target.value is 'clear'
            #             selected_tags.clear()
            #             $('#search').val('')
            #         else
            #             selected_tags.push e.target.value.toLowerCase().trim()
            #             $('#search').val('')
            #     when 8
            #         if e.target.value is ''
            #             selected_tags.pop()


    Template.facet.onRendered ->
        Meteor.setTimeout ->
            $('.accordion').accordion()
        , 1500

    Template.facet.events
        # 'click .ui.accordion': ->
        #     $('.accordion').accordion()

        'click .toggle_selection': ->
            delta = Docs.findOne type:'delta'
            facet = Template.currentData()

            Session.set 'loading', true
            if facet.filters and @name in facet.filters
                Meteor.call 'remove_facet_filter', delta._id, facet.key, @name, ->
                    Session.set 'loading', false
            else
                Meteor.call 'add_facet_filter', delta._id, facet.key, @name, ->
                    Session.set 'loading', false

        'keyup .add_filter': (e,t)->
            if e.which is 13
                delta = Docs.findOne type:'delta'
                facet = Template.currentData()
                filter = t.$('.add_filter').val()
                Session.set 'loading', true
                Meteor.call 'add_facet_filter', delta._id, facet.key, filter, ->
                    Session.set 'loading', false
                t.$('.add_filter').val('')




    Template.facet.helpers
        filtering_res: ->
            delta = Docs.findOne type:'delta'
            filtering_res = []
            if @key is '_keys'
                @res
            else
                for filter in @res
                    if filter.count < delta.total
                        filtering_res.push filter
                    else if filter.name in @filters
                        filtering_res.push filter
                filtering_res



        toggle_value_class: ->
            facet = Template.parentData()
            delta = Docs.findOne type:'delta'
            if Session.equals 'loading', true
                 'disabled'
            else if facet.filters.length > 0 and @name in facet.filters
                'grey'
            else ''

    Template.delta_result.onRendered ->
        # Meteor.setTimeout ->
        #     $('.progress').popup()
        # , 2000
    Template.delta_result.onCreated ->
        @autorun => Meteor.subscribe 'doc', @data._id

    Template.delta_result.helpers
        result: ->
            if Docs.findOne @_id
                Docs.findOne @_id
            else if Meteor.users.findOne @_id
                Meteor.users.findOne @_id

    Template.delta_result.events
        'click .set_type': ->
            Meteor.call 'set_delta_facets', @slug, Meteor.userId()

        'click .route_type': ->
            Session.set 'loading', true
            Meteor.call 'set_facets', @slug, ->
                Session.set 'loading', false
            # delta = Docs.findOne type:'delta'
            # Docs.update delta._id,
            #     $set:type_filter:@slug
            #
            # Meteor.call 'fum', delta._id, (err,res)->



if Meteor.isServer
    Meteor.publish 'type_from_slug', (type_slug)->
        if type_slug in ['type','brick','field','tribe','block','page']
            Docs.find
                type:'type'
                slug:type_slug
        else
            match = {}
            # if tribe_slug then match.slug = tribe_slug
            match.type = 'type'
            match.slug = type_slug

            Docs.find match

    Meteor.publish 'type_from_doc_id', (type, id)->
        doc = Docs.findOne id
        # console.log 'pub', tribe_slug, type, id
        if type in ['type','tribe','page','block','brick']
            Docs.find
                type:'type'
                slug:doc.type
        else
            match = {}
            match.type = 'type'
            match.slug = doc.type

            Docs.find match


    Meteor.publish 'type_fields_from_slug', (type_slug)->
        # console.log type

        # else if type in ['field', 'brick','tribe','page','block','type']
        type = Docs.findOne
            type:'type'
            slug:type_slug
            # tribe:tribe_slug
        # else
        #     type = Docs.findOne
        #         type:'type'
        #         slug:type
        #         tribe:tribe_slug

        Docs.find
            type:'field'
            parent_id:type._id


    Meteor.publish 'my_delta', ->
        Docs.find
            _author_id:Meteor.userId()
            type:'delta'
