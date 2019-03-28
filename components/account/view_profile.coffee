if Meteor.isClient
    Template.view_profile.onCreated ->
        @autorun -> Meteor.subscribe('user_profile', Router.current().params.user_id)


    Template.view_profile.helpers
        person: ->
            Meteor.users.findOne Router.current().params.user_id

        can_edit_profile: -> Meteor.userId() is Router.current().params.user_id or Roles.userIsInRole(Meteor.userId(),'dev')

    Template.view_profile.events
