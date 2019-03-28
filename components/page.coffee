if Meteor.isClient
    Template.page.onCreated ->
        console.log @
        @autorun => Meteor.subscribe 'page_doc', @data.slug


if Meteor.isServer
    Meteor.publish 'page_doc', (page_slug)->
        Docs.find
            type:'page'
            slug:page_slug
