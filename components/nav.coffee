if Meteor.isClient
    Template.nav.events
        'click #logout': ->
            Session.set 'logging_out', true
            Meteor.logout ->
                Session.set 'logging_out', false
                Router.go '/'

        'click .test_email': ->
            Meteor.call 'test_email'


    Template.nav.onCreated ->
        @autorun ->
            Meteor.subscribe 'me'
            Meteor.subscribe 'my_notifications'

    Template.nav.helpers
        notifications: ->
            Docs.find
                type:'notification'

        logging_out: -> Session.get 'logging_out'


if Meteor.isServer
    Meteor.publish 'my_notifications', ->
        Docs.find
            type:'notification'
