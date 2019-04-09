
# PrettyEmail.options =
#   from: 'admin@henry-health.com'
#   logoUrl: 'https://henry-health.com/wp-content/uploads/2018/05/xHenryHealth-LogoREV_clr.png.pagespeed.ic.BMtMqydFa0.png'
#   companyName: 'Henry Health'
#   companyUrl: 'http://henry-health.com'
#   companyAddress: '2231 Crystal Drive, Suite 1000, Arlington, VA, 22202'
#   companyTelephone: '+2023503372'
#   companyEmail: 'admin@henry-health.com'
#   siteName: 'Henry Health'


Meteor.methods
    test_email: ->
        Accounts.sendVerificationEmail Meteor.userId()
        Accounts.sendResetPasswordEmail Meteor.userId()
        Accounts.sendEnrollmentEmail Meteor.userId()

Mailer.config
    from: 'Henry Health <admin@henry-health.com>',     # Default 'From:' address. Required.
    replyTo: 'Henry Health <admin@henry-health.com>',  # Defaults to `from`.
    routePrefix: 'emails',              # Route prefix.
    baseUrl: process.env.ROOT_URL,      # The base domain to build absolute link URLs from in the emails.
    testEmail: "repjackson@gmail.com",                    # Default address to send test emails to.
    logger: console                     # Injected logger (see further below)
    silent: false,                      # If set to `true`, any `Logger.info` calls won't be shown in the console to reduce clutter.
    addRoutes: process.env.NODE_ENV is 'development' # Add routes for previewing and sending emails. Defaults to `true` in development.
    language: 'html'                    # The template language to use. Defaults to 'html', but can be anything Meteor SSR supports (like Jade, for instance).
    plainText: true                     # Send plain text version of HTML email as well.
    plainTextOpts: {}                   # Options for `html-to-text` module. See all here: https://www.npmjs.com/package/html-to-text


Mailer.init
    templates: Templates        # Required. A key-value hash where the keys are the template names. See more below.
    helpers: {}          # Global helpers available for all templates.
    layout: false         # Global layout template.


Meteor.methods
    send_email: ->
        Mailer.send
            to: 'eric <repjackson@gmail.com>'           # 'To: ' address. Required.
            subject: 'Subject'                     # Required.
            template: 'test_email'               # Required.
            replyTo: 'Henry Health <admin@henry-health.com>'      # Override global 'ReplyTo: ' option.
            from: 'Henry Health <admin@henry-health.com>'         # Override global 'From: ' option.
            # cc: 'Name <name@domain.com>'           # Optional.
            # bcc: 'Name <name@domain.com>'          # Optional.
            data: {}                               # Optional. Render your email with a data object.
            attachments: []                         # Optional. Attach files using a mailcomposer format as an array of objects.
                                                    # Read more here: http://docs.meteor.com/#/full/email_send and here: https://github.com/nodemailer/mailcomposer/blob/7c0422b2de2dc61a60ba27cfa3353472f662aeb5/README.md#add-attachments
