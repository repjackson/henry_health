Meteor.methods
    change_username:  (username) ->
        user = Meteor.users.findOne username:username
        Accounts.setUsername(user._id, username)
        return "Updated Username: #{username}"


    add_email: (new_email) ->
        userId = Meteor.userId();
        Accounts.addEmail(userId, new_email);
        return "Updated Email to #{new_email}"


    verify_email: (user_id)->
        Accounts.sendVerificationEmail(user_id)

    validateEmail: (email) ->
        re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
        re.test String(email).toLowerCase()
