Template.edit_about.events
    'blur #about': ->
        about = $('#about').val()
        Docs.update Router.current().params.doc_id,
            $set: about: about