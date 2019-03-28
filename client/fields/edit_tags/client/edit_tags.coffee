Template.edit_tags.events
    'keydown #add_tag': (e,t)->
        if e.which is 13
            doc_id = Router.getParam('doc_id')
            tag = $('#add_tag').val().toLowerCase().trim()
            if tag.length > 0
                Docs.update doc_id,
                    $addToSet: tags: tag
                $('#add_tag').val('')

    'click .doc_tag': (e,t)->
        tag = @valueOf()
        Docs.update Router.getParam('doc_id'),
            $pull: tags: tag
        $('#add_tag').val(tag)

Template.edit_tags.helpers
    # doc_tag_class: ->
    #     if @valueOf() is Meteor.user().profile.current_herd then 'disabled' else ''