if Meteor.isClient
    Router.route '/posts', -> @render 'posts'
    Router.route '/post/edit/:doc_id', -> @render 'edit_post'
    Router.route '/post/view/:doc_id', -> @render 'post_page'

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


    Template.post_page.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params.doc_id



    Template.post_page.helpers
        post: -> Docs.findOne Router.current().params.doc_id


    Template.post_page.events
        'click .edit_post': ->
            Router.go "/post/edit/#{@_id}"



    Template.post.events
        'click .post_tag': ->
            if @valueOf() in selected_post_tags.array() then selected_post_tags.remove @valueOf() else selected_post_tags.push @valueOf()

        'click .edit_post': ->
            Router.go "/post/edit/#{@_id}"





if Meteor.isServer
    Meteor.publish 'my_posts', ->
        Docs.find
        author_id: @userId
