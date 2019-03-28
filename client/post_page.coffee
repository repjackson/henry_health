Template.post_page.onCreated ->
    @autorun -> Meteor.subscribe 'doc', Router.current().params.doc_id



Template.post_page.helpers
    post: -> Docs.findOne Router.current().params.doc_id


Template.post_page.events
    'click .edit_post': ->
        Router.go "/post/edit/#{@_id}"
