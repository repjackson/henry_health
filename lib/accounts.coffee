# AccountsTemplates.configure
#     defaultLayout: 'layout'
#     # defaultLayoutRegions:
#         # nav: ''
#     defaultContentRegion: 'main'
#     showForgotPasswordLink: true
#     overrideLoginErrors: true
#     enablePasswordChange: true
#
#     sendVerificationEmail: true
#     enforceEmailVerification: false
#     confirmPassword: true
#     continuousValidation: true
#     #displayFormLabels: true
#     #forbidClientAccountCreation: true
#     #formValidationFeedback: true
#     #homeRoutePath: '/'
#     showAddRemoveServices: true
#     #showPlaceholders: true
#
#     negativeValidation: true
#     positiveValidation: true
#     negativeFeedback: true
#     positiveFeedback: true
#
#     # Privacy Policy and Terms of Use
#     #privacyUrl: 'privacy'
#     #termsUrl: 'terms-of-use'

AccountsTemplates.configure({
    # // Behavior
    confirmPassword: true,
    defaultLayout: 'layout',
    enablePasswordChange: true,
    forbidClientAccountCreation: false,
    overrideLoginErrors: true,
    sendVerificationEmail: false,
    lowercaseUsername: false,
    focusFirstInput: true,

    # // Appearance
    showAddRemoveServices: false,
    showForgotPasswordLink: true,
    showLabels: true,
    showPlaceholders: true,
    showResendVerificationEmailLink: false,

    # // Client-side Validation
    continuousValidation: false,
    negativeFeedback: false,
    negativeValidation: true,
    positiveValidation: true,
    positiveFeedback: true,
    showValidating: true,

    # // Privacy Policy and Terms of Use
    # privacyUrl: 'privacy',
    # termsUrl: 'terms-of-use',

    # // Redirects
    homeRoutePath: '/',
    redirectTimeout: 4000,

    # // Hooks
    # onLogoutHook: myLogoutFunc,
    # onSubmitHook: mySubmitFunc,
    # preSignUpHook: myPreSubmitFunc,
    # postSignUpHook: myPostSubmitFunc,

    # // Texts
    # texts: {
    #   button: {
    #       signUp: "Register Now!"
    #   },
    #   socialSignUp: "Register",
    #   socialIcons: {
    #       "meteor-developer": "fa fa-rocket"
    #   },
    #   title: {
    #       forgotPwd: "Recover Your Password"
    #   },
    # },
});



pwd = AccountsTemplates.removeField('password')
AccountsTemplates.removeField 'email'
AccountsTemplates.addFields [
    {
        _id: 'username'
        type: 'text'
        displayName: 'username'
        required: true
        minLength: 3
    }
    {
        _id: 'email'
        type: 'email'
        required: false
        displayName: 'email'
        re: /.+@(.+){2,}\.(.+){2,}/
        errStr: 'Invalid email'
    }
    {
        _id: 'username_and_email'
        type: 'text'
        required: false
        displayName: 'Login'
    }
    pwd
]


AccountsTemplates.configureRoute 'changePwd'
AccountsTemplates.configureRoute 'forgotPwd'
AccountsTemplates.configureRoute 'resetPwd'
AccountsTemplates.configureRoute 'signIn'
AccountsTemplates.configureRoute 'signUp'
AccountsTemplates.configureRoute 'verifyEmail'
