if Meteor.isClient
    Template.register.onCreated ->
        Session.set 'username', null
    Template.register.events
        'keyup .username': ->
            username = $('.username').val()
            Session.set 'username', username
            Meteor.call 'find_username', username, (err,res)->
                if res
                    Session.set 'enter_mode', 'login'
                else
                    Session.set 'enter_mode', 'register'

        'keyup .password': ->
            password = $('.password').val()
            Session.set 'password', password

        'keyup .email': ->
            email = $('.email').val()
            Session.set 'email', email

        'keyup .password2': ->
            password2 = $('.password2').val()
            Session.set 'password2', password2


        'click .enter': (e,t)->
            username = $('.username').val()
            password = $('.password').val()
            email = $('.email').val()
            # if Session.equals 'enter_mode', 'register'
            # if confirm "register #{username}?"
            options = {
                username:username
                password:password
                email:email
                }
            console.log options
            Meteor.call 'create_user', options, (err,new_id)->
                if err
                    alert err.reason
                else
                    console.log new_id
                    Meteor.users.update new_id,
                        $set: roles: ['client']
                    Meteor.loginWithPassword username, password, (err,res)=>
                        if err
                            console.log err
                            alert err.reason
                        else
                            console.log new_id
                            Meteor.call 'send_admin_enrollment_email', new_id
                            Router.go "/user/#{username}/edit"


    Template.register.helpers
        username: -> Session.get 'username'

        can_submit: ->
            username = Session.get 'username'
            email = Session.get 'email'
            password = Session.get 'password'
            password2 = Session.get 'password2'
            if username and email
                if password.length > 0 and password is password2
                    true
                else
                    false

        registering: -> Session.equals 'enter_mode', 'register'

        enter_class: ->
            if Meteor.loggingIn() then 'loading disabled' else ''


if Meteor.isServer
    Meteor.methods
        create_user: (options)->
            Accounts.createUser options



        find_username: (username)->
            res = Accounts.findUserByUsername(username)
            return res

        new_demo_user: ->
            current_user_count = Meteor.users.find().count()
            console.log 'current_user_count', current_user_count

            options = {
                username:"user#{current_user_count}"
                password:"user#{current_user_count}"
                }

            create = Accounts.createUser options
            console.log 'create', create
            new_user = Meteor.users.findOne create
            return new_user
