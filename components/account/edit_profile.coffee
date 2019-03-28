if Meteor.isClient
    Template.edit_profile.onCreated ->
        @autorun -> Meteor.subscribe 'user_profile', Router.current().params.username

    # Template.edit_profile.onRendered ->
    #     console.log Meteor.users.findOne(Router.current().params.username)

    Template.edit_profile.helpers
        user: -> Meteor.users.findOne Router.current().params.username

    Template.edit_profile.events
        'blur #name': ->
            old_name_tags = @name_tags
            # console.log old_name_tags
            name = $('#name').val()
            split_name = name.match(/\S+/g)

            Meteor.users.update username:Router.current().params.username,
                $pullAll: tags: old_name_tags

            Meteor.users.update username:Router.current().params.username,
                $set:
                    name: name
                    name_tags: split_name
                $addToSet: tags: $each: split_name

        'blur #first_name': ->
            first_name = $('#first_name').val().trim()
            Meteor.users.update username:Router.current().params.username,
                $set: "first_name": first_name


        'blur #last_name': ->
            last_name = $('#last_name').val().trim()
            Meteor.users.update username:Router.current().params.username,
                $set: "last_name": last_name


        'blur #company': ->
            company = $('#company').val().trim()
            Meteor.users.update username:Router.current().params.username,
                $set: "company": company


        'blur #position': ->
            position = $('#position').val().trim()
            Meteor.users.update username:Router.current().params.username,
                $set: "position": position


        'blur #website': ->
            website = $('#website').val().trim()
            Meteor.users.update username:Router.current().params.username,
                $set:"website": website


        'blur #phone': ->
            phone = $('#phone').val().trim()
            Meteor.users.update username:Router.current().params.username,
                $set:"phone": phone


        'keydown #input_image_id': (e,t)->
            if e.which is 13
                image_id = $('#input_image_id').val().toLowerCase().trim()
                if image_id.length > 0
                    Meteor.users.update username:Router.current().params.username,
                        $set: image_id: image_id
                    $('#input_image_id').val('')


        'keydown #add_tag': (e,t)->
            if e.which is 13
                tag = $('#add_tag').val().toLowerCase().trim()
                if tag.length > 0
                    Meteor.users.update username:Router.current().params.username,
                        $addToSet: tags: tag
                    $('#add_tag').val('')

        'click .person_tag': (e,t)->
            tag = @valueOf()
            Meteor.users.update username:Router.current().params.username,
                $pull: tags: tag
            $('#add_tag').val(tag)

        'click #save_profile': ->
            Router.go "/user/#{@username}"

        "change input[type='file']": (e) ->
            files = e.currentTarget.files
            Cloudinary.upload files[0],
                # folder:"secret" # optional parameters described in http://cloudinary.com/documentation/upload_images#remote_upload
                # type:"private" # optional: makes the image accessible only via a signed url. The signed url is available publicly for 1 hour.
                (err,res) -> #optional callback, you can catch with the Cloudinary collection as well
                    # console.log "Upload Error: #{err}"
                    # console.dir res
                    if err
                        console.error 'Error uploading', err
                    else
                        Meteor.users.update username:Router.current().params.username,
                            $set: "image_id": res.public_id
                    return

        'click #remove_photo': ->
            Meteor.users.update username:Router.current().params.username,
                $unset: image_id: 1


if Meteor.isServer
    Meteor.publish 'my_profile', ->
        Meteor.users.find @userId,
            fields:
                tags: 1
                profile: 1
                username: 1
                published: 1
                image_id: 1


    Meteor.publish 'user_profile', (id)->
        Meteor.users.find id,
            fields:
                tags: 1
                profile: 1
                username: 1
                published: 1
                image_id: 1
