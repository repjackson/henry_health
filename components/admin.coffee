Router.route '/admin', -> @render 'user_table'

if Meteor.isClient
    Template.user_table.onCreated ->
        @autorun ->  Meteor.subscribe 'users'


    Template.user_table.helpers
        users: -> Meteor.users.find {}


    Template.user_table.events
        'click #add_user': ->

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
