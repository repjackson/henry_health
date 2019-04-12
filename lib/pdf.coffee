Meteor.methods
    generate_pdf: (user)->
        console.log user
        doc = new PDFDocument({size: 'A4', margin: 50})
        doc.fontSize(12)
        for key,value of user
            console.log key,value
            doc.text("#{key}", {align: 'center', width: 200})
            doc.moveDown();
            doc.text("#{value}", {align: 'center', width: 200})
            doc.moveDown();
        doc.write('client_dl.pdf')
