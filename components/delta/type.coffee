if Meteor.isClient
    Template.type_edit.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params.doc_id
        @autorun -> Meteor.subscribe 'fields_from_doc_id', Router.current().params.type_slug, Router.current().params.doc_id
        @autorun -> Meteor.subscribe 'type_from_doc_id', Router.current().params.type_slug, Router.current().params.doc_id


    Template.type_view.onCreated ->
        @autorun -> Meteor.subscribe 'type_from_doc_id', Router.current().params.type_slug, Router.current().params.doc_id
        @autorun -> Meteor.subscribe 'fields_from_doc_id', Router.current().params.type_slug, Router.current().params.doc_id
        @autorun -> Meteor.subscribe 'doc', Router.current().params.doc_id

    Template.type_edit.events
        'click .delete_type': ->
            if confirm 'Confirm delete type'
                Docs.remove @_id
                Router.go '/types'


    Template.type_doc_edit.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params.doc_id
        @autorun -> Meteor.subscribe 'fields_from_doc_id', Router.current().params.doc_id
        @autorun -> Meteor.subscribe 'type_from_doc_id', Router.current().params.type_slug, Router.current().params.doc_id


    Template.type_doc_view.onCreated ->
        @autorun -> Meteor.subscribe 'type_from_doc_id', Router.current().params.type_slug, Router.current().params.doc_id
        @autorun -> Meteor.subscribe 'fields_from_doc_id', Router.current().params.doc_id
        console.log Router.current().params.doc_id
        @autorun -> Meteor.subscribe 'doc', Router.current().params.doc_id



if Meteor.isServer
    Meteor.publish 'fields_from_doc_id', (doc_id)->
        console.log 'doc_id', doc_id
        doc = Docs.findOne doc_id
        # console.log 'doc', doc
        type =
            Docs.findOne
                type:'type'
                slug:doc.type
        # console.log "type", type

        Docs.find(
                type:'field'
                parent_id:type._id
            )
