if Meteor.isClient
    Router.route '/dashboard', -> @render 'dashboard'

    Template.dashboard.onCreated ->
        @autorun -> Meteor.subscribe('type_docs', 'article')
        # @autorun -> Meteor.subscribe('readings')

    Template.dashboard.helpers
        articles: ->
            Docs.find {type:'article'},
                sort:
                    publish_date: -1



    Template.dashboard.events
        # 'click #add_post': ->
        #     id = Docs.insert type: 'post'
        #     Router.go "/post/edit/#{id}"
