if Meteor.isClient
    Router.route '/m/:model_slug', -> @render 'model'
    Router.route '/m/:model_slug/:doc_id/edit', -> @render 'model_doc_edit'
    Router.route '/m/:model_slug/:doc_id/view', -> @render 'model_doc_view'

    @selected_tags = new ReactiveArray []

    Template.model.onCreated ->
        @autorun -> Meteor.subscribe('model_docs', selected_tags.array(), Router.current().params.model_slug)

    Template.model.helpers
        model_docs: ->
            Docs.find {type:Router.current().params.model_slug},
                sort:
                    timestamp: -1
                limit: 10

    Template.model.events
        'click #add_model_doc': ->
            id = Docs.insert type: Router.current().params.model_slug
            Router.go "/m/#{Router.current().params.model_slug}/#{id}/edit"

    Template.model_segment.helpers


    Template.model_doc_view.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params.doc_id

    Template.model_doc_view.helpers
        model: -> Docs.findOne Router.current().params.doc_id

    Template.model_doc_view.events
        'click .edit_model': ->
            Router.go "/model/edit/#{@_id}"


    Template.model_doc_view.events
        # 'click .model_tag': ->
        #     if @valueOf() in selected_model_tags.array() then selected_model_tags.remove @valueOf() else selected_model_tags.push @valueOf()
        #
        # 'click .edit_model': ->
        #     Router.go "/model/edit/#{@_id}"


    Template.model_doc_edit.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params.doc_id

    Template.model_doc_edit.helpers
        model_doc: -> Docs.findOne Router.current().params.doc_id


    Template.model_doc_edit.events



if Meteor.isServer
    Meteor.publish 'model_docs', (selected_tags, model_slug)->
        Docs.find
            model:model_slug
