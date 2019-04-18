if Meteor.isClient

    Template.types.onCreated ->
        @autorun -> Meteor.subscribe 'docs', selected_tags.array(), 'type'

    Template.types.onRendered ->

    Template.type_view.onCreated ->
        @autorun -> Meteor.subscribe 'type', Router.current().params.type_slug
        # @autorun -> Meteor.subscribe 'type_fields', Router.current().params.type_slug
        @autorun -> Meteor.subscribe 'docs', selected_tags.array(), Router.current().params.type_slug

    Template.type_view.helpers
        type: ->
            Docs.findOne
                type:'type'
                slug: Router.current().params.type_slug

        type_docs: ->
            type = Docs.findOne
                type:'type'
                slug: Router.current().params.type_slug

            Docs.find
                type:type.slug

        type_doc: ->
            type = Docs.findOne
                type:'type'
                slug: Router.current().params.type_slug
            "#{type.slug}_view"

        fields: ->
            Docs.find
                type:'field'
                # parent_id: Router.current().params.doc_id

    Template.type_view.events
        'click .add_child': ->
            new_id = Docs.insert
                type: Router.current().params.type_slug
            Router.go "/edit/#{new_id}"

    Template.type_edit.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params.doc_id
        @autorun -> Meteor.subscribe 'child_docs', Router.current().params.doc_id


    Template.types.helpers
        types: -> Docs.find { type: 'type' }

    Template.type_edit.helpers


    Template.types.events
        'click #add_type': ->
            # alert 'hi'
            id = Docs.insert type:'type'
            Router.go "/type/edit/#{id}"



    Template.type_edit.helpers
        type: ->
            doc_id = Router.current().params.doc_id
            # console.log doc_id
            Docs.findOne doc_id

        fields: ->
            Docs.find
                type:'field'
                parent_id: Router.current().params.doc_id

    Template.type_edit.events
        'click #delete_type': (e,t)->
            if confirm 'delete type?'
                Docs.remove Router.current().params.doc_id, ->
                    Router.go "/types"

        'click .add_field': ->
            Docs.insert
                type:'field'
                parent_id: Router.current().params.doc_id

if Meteor.isServer
    Meteor.publish 'type', (slug)->
        Docs.find
            type:'type'
            slug:slug

    Meteor.publish 'type_fields', (slug)->
        type = Docs.findOne
            type:'type'
            slug:slug
        Docs.find
            type:'field'
            parent_id:type._id

    Meteor.publish 'type_docs', (slug)->
        type = Docs.findOne
            type:'type'
            slug:slug
        Docs.find
            type:slug
