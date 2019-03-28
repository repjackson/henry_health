Template.publish_button.events
    'click #publish': ->
        Docs.update Router.current().params.doc_id,
            $set: published: true

    'click #unpublish': ->
        Docs.update Router.current().params.doc_id,
            $set: published: false
