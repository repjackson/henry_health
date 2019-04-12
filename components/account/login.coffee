if Meteor.isClient
    Template.login.onCreated ->
        Session.set 'username', null

    Template.login.events
        'keyup .username': ->
            username = $('.username').val()
            Session.set 'username', username
            Meteor.call 'find_username', username, (err,res)->
                if res
                    Session.set 'enter_mode', 'login'
                else
                    Session.set 'enter_mode', 'register'

        'blur .username': ->
            username = $('.username').val()
            Session.set 'username', username
            Meteor.call 'find_username', username, (err,res)->
                if res
                    Session.set 'enter_mode', 'login'
                else
                    Session.set 'enter_mode', 'register'

        'click .enter': (e,t)->
            e.preventDefault()
            username = $('.username').val()
            password = $('.password').val()
            options = {
                username:username
                password:password
                }
            console.log options
            Meteor.loginWithPassword username, password, (err,res)=>
                if err
                    console.log err
                    $('body').toast({
                        message: err.reason
                    })
                else
                    # console.log res
                    Router.go "/dashboard"

        'keyup .password': (e,t)->
            if e.which is 13
                e.preventDefault()
                username = $('.username').val()
                password = $('.password').val()
                options = {
                    username:username
                    password:password
                    }
                console.log options
                Meteor.loginWithPassword username, password, (err,res)=>
                    if err
                        console.log err
                        $('body').toast({
                            message: err.reason
                        })
                    else
                        # console.log res
                        Router.go "/dashboard"


    Template.login.helpers
        username: -> Session.get 'username'
        logging_in: -> Session.equals 'enter_mode', 'login'
        enter_class: -> if Meteor.loggingIn() then 'loading disabled' else ''



    Template.forgot_password.events
        'click .submit_email': (e, t) ->
            e.preventDefault()
            emailVar = $('.email').val()
            console.log 'emailVar : ' + emailVar

            trimInput = (val) -> val.replace /^\s*|\s*$/g, ''

            email_trim = trimInput(emailVar)
            email = email_trim.toLowerCase()
            Accounts.forgotPassword { email: email }, (err) ->
                if err
                    if err.message == 'User not found [403]'
                        console.log 'This email does not exist.'
                        alert 'This email does not exist.'
                    else
                        console.log 'We are sorry but something went wrong.'
                        alert 'We are sorry but something went wrong.'
                else
                    console.log 'Email Sent. Check your mailbox.'
                    alert 'Email Sent. Check your mailbox.'
