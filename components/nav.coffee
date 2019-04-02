if Meteor.isClient
    Template.nav.events
        'click #logout': ->
            Session.set 'logging_out', true
            Meteor.logout ->
                Session.set 'logging_out', false
                Router.go '/'

        'click .delta': ->
            Session.set 'loading', true
            Meteor.call 'set_delta_facets', 'schema',->
                Session.set 'loading', false

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
