if Meteor.isClient
    Template.register_therapist.onCreated ->
        Session.set 'username', null

    Template.register_therapist.events
        'keyup .username': ->
            username = $('.username').val()
            Session.set 'username', username
            Meteor.call 'find_username', username, (err,res)->
                if res
                    Session.set 'enter_mode', 'login'
                else
                    Session.set 'enter_mode', 'register'


        'click .enter': (e,t)->
            username = $('.username').val()
            password = $('.password').val()
            # if Session.equals 'enter_mode', 'register'
            # if confirm "register #{username}?"
            options = {
                username:username
                password:password
                }
            console.log options
            Meteor.call 'create_user', options, (err,res)->
                console.log res
                Meteor.users.update res,
                    $set: roles: ['therapist']
                Meteor.loginWithPassword username, password, (err,res)=>
                    if err
                        console.log err
                        alert err.reason
                        # if err.error is 403
                        #     Session.set 'message', "#{username} not found"
                        #     Session.set 'enter_mode', 'register'
                        #     Session.set 'username', "#{username}"
                    else
                        console.log res

                        Router.go "/user/#{username}/edit"
            # else
            #     Meteor.loginWithPassword username, password, (err,res)=>
            #         if err
            #             if err.error is 403
            #                 Session.set 'message', "#{username} not found"
            #                 Session.set 'enter_mode', 'register'
            #                 Session.set 'username', "#{username}"
            #         else
            #             Router.go '/'


    Template.register_therapist.helpers
        username: -> Session.get 'username'

        registering: -> Session.equals 'enter_mode', 'register'

        enter_class: ->
            if Meteor.loggingIn() then 'loading disabled' else ''
