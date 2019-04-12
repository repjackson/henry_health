Meteor.methods
    generate_pdf: (user)->
        console.log user
        doc = new PDFDocument({size: 'A4', margin: 50})
        doc.fontSize(12)
        doc.text('PDFKit is simple', 10, 30, {align: 'center', width: 200})
        doc.moveDown();
        doc.text(user, 10, 30, {align: 'center', width: 200})
        doc.write('client_dl.pdf')
