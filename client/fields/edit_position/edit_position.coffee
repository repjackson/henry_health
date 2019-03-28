if Meteor.isClient
    Template.edit_position.events
        'change #position': ->
            doc_id = Router.getParam('doc_id')
            position = $('#position').val()
    
            Docs.update doc_id,
                $set: position: position


