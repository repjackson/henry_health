if Meteor.isClient
    Template.edit_position.events
        'change #position': ->
            doc_id = Router.current().params.doc_id
            position = $('#position').val()
    
            Docs.update doc_id,
                $set: position: position


