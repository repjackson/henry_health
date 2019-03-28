if Meteor.isClient
    Router.route '/posts', -> @render 'posts'
    Router.route '/post/edit/:doc_id', -> @render 'post_edit'
    Router.route '/post/view/:doc_id', -> @render 'post_view'

    @selected_post_tags = new ReactiveArray []

    Template.posts.onCreated ->
        @autorun -> Meteor.subscribe('docs', selected_post_tags.array(), 'post')

    Template.posts.helpers
        posts: ->
            Docs.find {},
                sort:
                    publish_date: -1
                limit: 10

    Template.posts.events
        'click #add_post': ->
            id = Docs.insert type: 'post'
            Router.go "/post/edit/#{id}"


if Meteor.isClient
    Template.my_posts.onCreated ->
        @autorun -> Meteor.subscribe('my_posts')


    Template.my_posts.helpers
        my_posts: ->
            Docs.find {},
                sort:
                    publish_date: -1


    Template.post_segment.helpers
        tag_class: -> if @valueOf() in selected_post_tags.array() then 'primary' else 'basic'

        can_edit: -> @author_id is Meteor.userId()


    Template.post_view.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params.doc_id



    Template.post_view.helpers
        post: -> Docs.findOne Router.current().params.doc_id


    Template.post_view.events
        'click .edit_post': ->
            Router.go "/post/edit/#{@_id}"



    Template.post_view.events
        'click .post_tag': ->
            if @valueOf() in selected_post_tags.array() then selected_post_tags.remove @valueOf() else selected_post_tags.push @valueOf()

        'click .edit_post': ->
            Router.go "/post/edit/#{@_id}"


    Template.post_edit.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params.doc_id

    Template.post_edit.helpers
        post: -> Docs.findOne Router.current().params.doc_id


    Template.post_edit.events
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



if Meteor.isServer
    Meteor.publish 'my_posts', ->
        Docs.find
            author_id: @userId
