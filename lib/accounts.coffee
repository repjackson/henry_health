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
    sendVerificationEmail: true,
    lowercaseUsername: false,
    focusFirstInput: true,

    # // Appearance
    showAddRemoveServices: false,
    showForgotPasswordLink: true,
    showLabels: true,
    showPlaceholders: true,
    showResendVerificationEmailLink: true,

    # // Client-side Validation
    continuousValidation: true,
    negativeFeedback: false,
    negativeValidation: true,
    positiveValidation: true,
    positiveFeedback: true,
    showValidating: true,

    # // Privacy Policy and Terms of Use
    privacyUrl: 'privacy',
    termsUrl: 'terms-of-use',

    # // Redirects
    homeRoutePath: '/dashboard',
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

AccountsTemplates.configure
    texts:
        button:
          changePwd: "Change password"
          enrollAccount: "Enroll"
          forgotPwd: "Forgot Password"
          resetPwd: "Reset Password"
          signIn: "Sign In"
          signUp: "Enroll"


pwd = AccountsTemplates.removeField('password')
AccountsTemplates.removeField 'email'


# AccountsTemplates.addField
#     _id: 'fruit'
#     type: 'checkboxes'
#     displayName: 'Preferred Fruit'
#     select: [
#         {
#             text: 'Apple'
#             value: 'aa'
#         }
#         {
#             text: 'Banana'
#             value: 'bb'
#         }
#         {
#             text: 'Carrot'
#             value: 'cc'
#         }
#     ]

# Which of the following are major sources of stress for you? *
#  Time Management
#  Personal Expectations
#  Family Expectations and Family Life
#  Money and Finances
#  Physical Health Issues
#  Living Arrangements
#  Work/Employment Decisions
#  Relationships
#  Academic Demands
#  Daily Hassles


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
    # {
    #     _id: 'fruit'
    #     type: 'radio'
    #     displayName: 'Preferred Fruit'
    #     select: [
    #         {
    #           text: 'Apple'
    #           value: 'aa'
    #         }
    #         {
    #           text: 'Banana'
    #           value: 'bb'
    #         }
    #         {
    #           text: 'Carrot'
    #           value: 'cc'
    #         }
    #     ]
    # }
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
