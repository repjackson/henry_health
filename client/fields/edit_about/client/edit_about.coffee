Template.edit_about.events
    'blur #about': ->
        about = $('#about').val()
        Docs.update Router.getParam('doc_id'),
            $set: about: about