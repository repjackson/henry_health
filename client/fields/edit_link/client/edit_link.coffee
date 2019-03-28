Template.edit_link.events
    'blur #link': ->
        link = $('#link').val()
        Docs.update Router.getParam('doc_id'),
            $set: link: link