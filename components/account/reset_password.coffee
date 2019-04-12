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
