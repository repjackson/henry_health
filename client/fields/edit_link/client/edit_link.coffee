Template.edit_link.events
    'blur #link': ->
        link = $('#link').val()
        Docs.update Router.current().params.doc_id,
            $set: link: link