Template.edit_featured.events
    'click #make_featured': ->
        Docs.update Router.getParam('doc_id'),
            $set: featured: true

    'click #make_unfeatured': ->
        Docs.update Router.getParam('doc_id'),
            $set: featured: false
