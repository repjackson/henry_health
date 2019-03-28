Template.edit_post.onCreated ->
    @autorun -> Meteor.subscribe 'doc', Router.current().params.doc_id

Template.edit_post.helpers
    post: -> Docs.findOne Router.current().params.doc_id


Template.edit_post.events
    'click #save_post': ->
        title = $('#title').val()
        publish_date = $('#publish_date').val()
        body = $('#body').val()
        Docs.update Router.current().params.doc_id,
            $set:
                title: title
                publish_date: publish_date
                body: body
        Router.go "/post/view/#{@_id}"

    'blur #title': ->
        title = $('#title').val()
        Docs.update Router.current().params.doc_id,
            $set: title: title


    'keydown #add_tag': (e,t)->
        if e.which is 13
            doc_id = Router.current().params.doc_id
            tag = $('#add_tag').val().toLowerCase().trim()
            if tag.length > 0
                Docs.update doc_id,
                    $addToSet: tags: tag
                $('#add_tag').val('')

    'click .doc_tag': (e,t)->
        tag = @valueOf()
        Docs.update Router.current().params.doc_id,
            $pull: tags: tag
        $('#add_tag').val(tag)


    'click #publish': ->
        Docs.update Router.current().params.doc_id,
            $set: published: true

    'click #unpublish': ->
        Docs.update Router.current().params.doc_id,
            $set: published: false

    'click #make_featured': ->
        Docs.update Router.current().params.doc_id,
            $set: featured: true

    'click #make_unfeatured': ->
        Docs.update Router.current().params.doc_id,
            $set: featured: false

    'click #delete_post': ->
        swal {
            title: 'Delete?'
            # text: 'Confirm delete?'
            type: 'error'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            Docs.remove Router.current().params.doc_id, ->
                Router.go "/posts"
