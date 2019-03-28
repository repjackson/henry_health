Template.publish_button.events
    'click #publish': ->
        Docs.update Router.getParam('doc_id'),
            $set: published: true

    'click #unpublish': ->
        Docs.update Router.getParam('doc_id'),
            $set: published: false
