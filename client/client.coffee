@selected_tags = new ReactiveArray []


$.cloudinary.config
    cloud_name:"facet"


Router.notFound =
    action: ->
        BlazeLayout.render 'layout',
            main: 'not_found'

Template.body.events
    'click .toggle_sidebar': -> $('.ui.sidebar').sidebar('toggle')
Session.setDefault 'invert', false
Template.registerHelper 'dark_side', () -> Session.equals('invert',true)
Template.registerHelper 'invert_class', () -> if Session.equals('invert',true) then 'invert' else ''
Template.registerHelper 'is_loading', () -> Session.get 'loading'
Template.registerHelper 'dev', () -> Meteor.isDevelopment
Template.registerHelper 'is_author', () -> @_author_id is Meteor.userId()
Template.registerHelper 'to_percent', (number) -> (number*100).toFixed()
Template.registerHelper 'long_date', (input) -> moment(input).format("dddd, MMMM Do h:mm:ss a")
Template.registerHelper 'when', () -> moment(@_timestamp).fromNow()
Template.registerHelper 'from_now', (input) -> moment(input).fromNow()

Template.registerHelper 'current_type', (input) -> Router.current().params.type
Template.registerHelper 'current_model', (input) ->
    Docs.findOne
        model:'model'
        slug: Router.current().params.model_slug

Template.registerHelper 'is_admin', () ->
    if Meteor.user() and Meteor.user().roles
        # if _.intersection(['dev','admin'], Meteor.user().roles) then true else false
        if 'admin' in Meteor.user().roles then true else false

Template.registerHelper 'is_dev', () ->
    if Meteor.user() and Meteor.user().roles
        if 'dev' in Meteor.user().roles then true else false


Template.registerHelper 'is_editing', () ->
    # console.log 'this', @
    Session.equals 'editing_id', @_id

Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)


Template.registerHelper 'user_from_username_param', () ->
    found = Meteor.users.findOne username:Router.current().params.username
    # console.log found
    found

Template.registerHelper 'field_value', () ->
    parent = Template.parentData()
    parent["#{@key}"]


Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')

Template.registerHelper 'publish_when', () -> moment(@publish_date).fromNow()
Template.registerHelper 'when', () -> moment(@timestamp).fromNow()
Template.registerHelper 'is_dev', () -> Meteor.isDevelopment


Template.registerHelper 'calculated_size', (metric) ->
    # console.log metric
    # console.log typeof parseFloat(@relevance)
    # console.log typeof (@relevance*100).toFixed()
    whole = parseInt(@["#{metric}"]*10)
    # console.log whole

    if whole is 2 then 'f2'
    else if whole is 3 then 'f3'
    else if whole is 4 then 'f4'
    else if whole is 5 then 'f5'
    else if whole is 6 then 'f6'
    else if whole is 7 then 'f7'
    else if whole is 8 then 'f8'
    else if whole is 9 then 'f9'
    else if whole is 10 then 'f10'




Template.sidebar.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.context.example .ui.sidebar')
                    .sidebar({
                        context: $('.context.example .bottom.segment')
                        dimPage: false
                        transition:  'push'
                    })
                    .sidebar('attach events', '.context.example .menu .toggle_sidebar.item')
            , 500


Template.camera.onRendered ->
    Webcam.on 'error', (err) ->
        console.log err
        # outputs error to console instead of window.alert
    Webcam.set
        width: 320
        height: 240
        dest_width: 640
        dest_height: 480
        image_format: 'jpeg'
        jpeg_quality: 90
    Webcam.attach '#webcam'

Template.camera.events 'click .snap': ->
    Webcam.snap (image) ->
        Session.set 'webcamSnap', image


Template.camera.helpers
    image: -> Session.get 'webcamSnap'
