if Meteor.isClient
    Template.reset_password.onCreated ->
        if Accounts._resetPasswordToken
            # var resetPassword = Router.current().params.token;
            Session.set 'resetPassword', Accounts._resetPasswordToken
            console.log 'reset_passwordtemplate : ' + resetPassword


    Template.reset_password.helpers
        resetPassword: ->
            # console.log('reset_password : ' + resetPassword);
            resetPassword = Router.current().params.token
            # console.log('reset_password : ' + resetPassword);
            resetPassword
            # return Session.get('resetPassword');


    Template.reset_password.events
        'submit #reset_password_form': (e, t) ->
            e.preventDefault()
            resetPassword = Router.current().params.token
            # console.log('reset_password : ' + resetPassword);
            reset_password_form = $(e.currentTarget)
            password = reset_password_form.find('.password1').val()
            password_confirm = reset_password_form.find('.password2').val()
            #Check password is at least 6 chars long

            is_valid_password = (password, password_confirm) ->
                if password == password_confirm
                    # console.log if 'passwordVar.length' + password.length >= 6 then true else false
                    if password.length >= 6 then true else false
                else
                    alert 'Passwords dont match'

            if is_valid_password(password, password_confirm)
                # if (isNotEmpty(password) && areValidPasswords(password, password_confirm)) {
                Accounts.resetPassword resetPassword, password, (err) ->
                    if err
                        console.log 'We are sorry but something went wrong.'
                    else
                        console.log 'Your password has been changed. Welcome back!'
                        Session.set 'resetPassword', null
                        Router.go '/'
            else
                alert 'password should be at least 6 characters long'



    Template.forgot_password.onCreated ->
        @autorun -> Meteor.subscribe 'users'

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


        'click .submit_username': (e, t) ->
            e.preventDefault()
            username = $('.username').val().trim()
            console.log 'username : ' + username

            user = Meteor.users.findOne username:username
            email = user.emails[0].address
            if not email
                alert "No email found for user.  Please contact admin@henry-health.com."

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
