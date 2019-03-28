Template.edit_featured.events
    'click #make_featured': ->
        Docs.update Router.current().params.doc_id,
            $set: featured: true

    'click #make_unfeatured': ->
        Docs.update Router.current().params.doc_id,
            $set: featured: false
