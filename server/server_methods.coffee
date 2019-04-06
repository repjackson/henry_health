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
