Router.configure
    layoutTemplate: 'layout'
    notFoundTemplate: 'not_found'
    loadingTemplate: 'splash'
    trackPageView: true


Router.route '/chat', -> @render 'view_chats'
Router.route '/add', -> @render 'add'
Router.route '/pages', -> @render 'pages'
Router.route '/menu', -> @render 'menu'
Router.route '/me', -> @render 'me'
# Router.route '/users', -> @render 'users'
Router.route '/inbox', -> @render 'inbox'


Router.route('enroll', {
    path: '/enroll-account/:token'
    template: 'reset_password'
    onBeforeAction: ()=>
        Meteor.logout()
        Session.set('_resetPasswordToken', this.params.token)
        @subscribe('enrolledUser', this.params.token).wait()
})



# Router.route '/user/:username', -> @render 'user'
Router.route '/edit/:_id', -> @render 'edit'
Router.route '/view/:_id', -> @render 'view'
Router.route '*', -> @render 'not_found'

# Router.route '/user/:username/s/:type', -> @render 'profile_layout', 'user_section'


Router.route '/add_resident', (->
    @layout 'nonav'
    @render 'add_resident'
    ), name:'add_resident'


Router.route '/user/:username/s/:type', (->
    @layout 'profile_layout'
    @render 'user_section'
    ), name:'user_section'


Router.route '/user/:username/about', (->
    @layout 'profile_layout'
    @render 'user_about'
    ), name:'user_about'

Router.route '/user/:username', (->
    @layout 'profile_layout'
    @render 'user_about'
    ), name:'user_home'

Router.route '/user/:username/stripe', (->
    @layout 'profile_layout'
    @render 'user_stripe'
    ), name:'user_stripe'

Router.route '/user/:username/blog', (->
    @layout 'profile_layout'
    @render 'user_blog'
    ), name:'user_blog'

Router.route '/user/:username/events', (->
    @layout 'profile_layout'
    @render 'user_events'
    ), name:'user_events'

Router.route '/user/:username/tags', (->
    @layout 'profile_layout'
    @render 'user_tags'
    ), name:'user_tags'

Router.route '/user/:username/tasks', (->
    @layout 'profile_layout'
    @render 'user_tasks'
    ), name:'user_tasks'

Router.route '/user/:username/connections', (->
    @layout 'profile_layout'
    @render 'user_connections'
    ), name:'user_connections'


Router.route '/user/:username/messages', (->
    @layout 'profile_layout'
    @render 'user_messages'
    ), name:'user_messages'


Router.route '/user/:username/notifications', (->
    @layout 'profile_layout'
    @render 'user_notifications'
    ), name:'user_notifications'




Router.route '/user/:username/chat', (->
    @layout 'profile_layout'
    @render 'user_chat'
    ), name:'user_chat'

Router.route '/user/:username/gallery', (->
    @layout 'profile_layout'
    @render 'user_gallery'
    ), name:'user_gallery'

Router.route '/user/:username/contact', (->
    @layout 'profile_layout'
    @render 'user_contact'
    ), name:'user_contact'

# Router.route '/user/:username/campaigns', (->
#     @layout 'profile_layout'
#     @render 'user_campaigns'
#     ), name:'user_campaigns'


Router.route '/user/:username/edit', -> @render 'user_edit'


Router.route '/p/:slug', -> @render 'page'

Router.route '/settings', -> @render 'settings'

# Router.route '/users', -> @render 'people'


# Router.route '/', (->
#     @layout 'layout'
#     @render 'alpha'
#     ), name:'alpha'



Router.route '/t/:tribe_slug/', (->
    @layout 'layout'
    @render 'tribe_home'
    ), name:'tribe_home'


Router.route '/t/:tribe_slug/s/:type', (->
    @layout 'layout'
    @render 'delta'
    ), name:'tribe_delta'


# Router.route '/s/:type', -> @render 'delta'
Router.route '/t/:tribe_slug/s/:type/:_id/edit', -> @render 'type_edit'
Router.route '/t/:tribe_slug/s/:type/:_id/view', -> @render 'type_view'
