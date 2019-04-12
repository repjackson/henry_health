Meteor.methods
    generate_pdf: (user)->
        # console.log user
        doc = new PDFDocument({size: 'A4', margin: 50})
        doc.fontSize(12)
        for key,value of user
            console.log key,value
            doc.font('Times-Roman').text("#{key}: ", {align: 'left', continued:true})
            doc.font('Times-Bold').text(" #{value}", {align: 'left'})
            doc.moveDown();
        doc.write("#{user.first_name}_#{user.last_name}_profile.pdf")
