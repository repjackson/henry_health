if Meteor.isClient
    Template.type_edit.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params._id, Router.current().params.type
        @autorun -> Meteor.subscribe 'bricks_from_doc_id', Router.current().params.type, Router.current().params._id
        @autorun -> Meteor.subscribe 'schema_from_doc_id', Router.current().params.type, Router.current().params._id


    Template.type_view.onCreated ->
        @autorun -> Meteor.subscribe 'schema_from_doc_id', Router.current().params.type, Router.current().params._id
        @autorun -> Meteor.subscribe 'bricks_from_doc_id', Router.current().params.type, Router.current().params._id
        @autorun -> Meteor.subscribe 'doc', Router.current().params._id, Router.current().params.type

    Template.type_edit.events
        'click .delete_schema': ->
            if confirm 'Confirm delete schema'
                Docs.remove @_id
                Router.go '/schemas'

if Meteor.isServer
    Meteor.publish 'bricks_from_doc_id', (schema, id)->
        doc = Docs.findOne id
        console.log 'pub bricks', schema, id
        schema = Docs.findOne
            type:'schema'
            slug:doc.type
        Docs.find
            type:'brick'
            parent_id:schema._id


    Meteor.publish 'schema_from_doc_id', ( schema, id)->
        doc = Docs.findOne id
        # console.log 'pub', tribe_slug, schema, id
        Docs.find
            type:'schema'
            slug:doc.type
