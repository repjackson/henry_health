if Meteor.isClient
    Template.edit_profile.onCreated ->
        @autorun -> Meteor.subscribe 'user_profile', Router.current().params.username

    # Template.edit_profile.onRendered ->
    #     console.log Meteor.users.findOne(Router.current().params.username)

    Template.edit_profile.helpers
        user: -> Meteor.users.findOne Router.current().params.username

    Template.edit_profile.events
        'blur #name': ->
            old_name_tags = @name_tags
            # console.log old_name_tags
            name = $('#name').val()
            split_name = name.match(/\S+/g)

            Meteor.users.update username:Router.current().params.username,
                $pullAll: tags: old_name_tags

            Meteor.users.update username:Router.current().params.username,
                $set:
                    name: name
                    name_tags: split_name
                $addToSet: tags: $each: split_name


        'click #save_profile': ->
            Router.go "/user/#{@username}"



if Meteor.isServer
    Meteor.publish 'my_profile', ->
        Meteor.users.find @userId,
            fields:
                tags: 1
                profile: 1
                username: 1
                published: 1
                image_id: 1


    Meteor.publish 'user_profile', (id)->
        Meteor.users.find id,
            fields:
                tags: 1
                profile: 1
                username: 1
                published: 1
                image_id: 1
