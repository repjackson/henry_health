Router.configure
    layoutTemplate: 'layout'
    notFoundTemplate: 'not_found'
    loadingTemplate: 'splash'
    trackPageView: true

if Meteor.isClient
  #redirects user to login page if not logged in
    requireLogin = ->
        if !Meteor.user()
            # if Meteor.loggingIn()
            #     Router.go 'home'
            #     @next()
            # else
            Router.go 'login'
            @next()
        else
            @next()
        return

    # Router.onBeforeAction requireLogin, except: [ 'register','register_therapist','home','login','reset_password' ]


Router.route '/me', -> @render 'me'
Router.route '/forgot_password', -> @render 'forgot_password'
Router.route '/register', -> @render 'register'
Router.route '/register_therapist', -> @render 'register_therapist'


Router.route '/verify-email/:token', ->
    # onBeforeAction: ->
    console.log @
    # Session.set('_resetPasswordToken', this.params.token)
    # @subscribe('enrolledUser', this.params.token).wait()
    console.log @params
    Accounts.verifyEmail(@params.token, (err) =>
        if err
            console.log err
            alert err
        else
            Router.go '/dashboard'
    )

Router.route '/reset_password/:token', -> @render 'reset_password'


Router.route('enroll', {
    path: '/enroll-account/:token'
    template: 'reset_password'
    onBeforeAction: ()=>
        Meteor.logout()
        Session.set('_resetPasswordToken', this.params.token)
        @subscribe('enrolledUser', this.params.token).wait()
})


# Router.route '/user/:username', -> @render 'user'
Router.route '/edit/:doc_id', -> @render 'edit'
Router.route '/view/:doc_id', -> @render 'view'
Router.route '*', -> @render 'not_found'

# Router.route '/user/:username/s/:type', -> @render 'profile_layout', 'user_section'


Router.route '/user/:username', (->
    @layout 'profile_layout'
    @render 'user_about'
    ), name:'user_home'

Router.route '/', (->
    @layout 'layout'
    @render 'home'
    ), name:'home'



Router.route '/user/:username/edit', -> @render 'user_edit'

Router.route '/settings', -> @render 'settings'

# Router.route '/users', -> @render 'people'

Router.route '/login', -> @render 'login'
