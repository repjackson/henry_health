Router.route '/admin', -> @render 'admin'

if Meteor.isClient
    Template.user_table.onCreated ->
        @autorun ->  Meteor.subscribe 'users'


    Template.user_table.helpers
        users: -> Meteor.users.find {}


    Template.user_table.events
        'click #add_user': ->

        'click .generate_pdf': ->
            console.log @
            Meteor.call 'generate_pdf', @

        'click .remove_staff': ->
            self = @
            swal {
                title: "Remove #{@emails[0].address} from staffs?"
                # text: 'You will not be able to recover this imaginary file!'
                type: 'warning'
                animation: false
                showCancelButton: true
                # confirmButtonColor: '#DD6B55'
                confirmButtonText: 'Remove Privilages'
                closeOnConfirm: false
            }, ->
                Roles.removeUsersFromRoles self._id, 'staff'
                swal "Removed staff Privilages from #{self.emails[0].address}", "",'success'
                return


        'click .make_staff': ->
            self = @
            swal {
                title: "Make #{@emails[0].address} an staff?"
                # text: 'You will not be able to recover this imaginary file!'
                type: 'warning'
                animation: false
                showCancelButton: true
                # confirmButtonColor: '#DD6B55'
                confirmButtonText: 'Make staff'
                closeOnConfirm: false
            }, ->
                Roles.addUsersToRoles self._id, 'staff'
                swal "Made #{self.emails[0].address} a staff", "",'success'
                return

    Template.user_role_toggle.helpers
        is_in_role: ->
            @role in Template.parentData().roles

    Template.user_role_toggle.events
        'click .add_role': ->
            parent_user = Template.parentData()
            Meteor.users.update parent_user._id,
                $addToSet:roles:@role

        'click .remove_role': ->
            parent_user = Template.parentData()
            Meteor.users.update parent_user._id,
                $pull:roles:@role






    Template.article_list.onCreated ->
        @autorun ->  Meteor.subscribe 'type', 'article'


    Template.article_list.helpers
        articles: ->
            Docs.find
                type:'article'

    Template.article_list.events
        'click .add_article': ->
            Docs.insert
                type:'article'

        'click .delete_article': ->
            if confirm 'Delete article?'
                Docs.remove @_id
