# Meteor.methods
#     send_email: (mail_fields) ->
#         @unblock()
#
#         data = {
#             to: mail_fields.to
#             from: mail_fields.from
#             subject: mail_fields.subject
#             text: mail_fields.text
#             html: mail_fields.html
#         }
#         console.log 'sending email', data
#         # if Meteor.isProduction
#         #     mailgun.messages().send data, (error, body)->
#         #       console.log(body)
#         if Meteor.isDevelopment
#             # mailgun.messages().send data, (error, body)->
#             #   console.log(body)
#             console.log 'sending email in dev', data
#             Email.send({
#                 to: data.to,
#                 from: data.from,
#                 subject: data.subject,
#                 text: text
#                 });
#         return
#
#
#
#
#     send_email_about_ticket_assignment:(ticket_doc_id, username)->
#         ticket = Docs.findOne ticket_doc_id
#
#         # assigned_to_user = Meteor.users.findOne username:username
#         # ticket_link = "https://www.jan.meteorapp.com/p/ticket_admin_view?doc_id=#{ticket._id}"
#         # complete_ticket_link = "https://www.jan.meteorapp.com/p/complete_ticket_task?doc_id=#{ticket._id}&unassign=#{username}"
#
#         mail_fields = {
#             # to: ["<#{assigned_to_user.emails[0].address}>"]
#             to: ["<repjackson@gmail.com>"]
#             from: "Henry Health <portal@jan-pro.com>"
#             subject: "#{username} you have been assigned to ticket ##{ticket.ticket_number} from customer: #{ticket.customer_name}."
#             html: "<h4>#{username}, you have been assigned to ticket ##{ticket.ticket_number} from customer: #{ticket.customer_name}.</h4>
#                 <ul>
#                     <li>Type: #{ticket.ticket_type}</li>
#                     <li>Number: #{ticket.ticket_number}</li>
#                     <li>Details: #{ticket.ticket_details}</li>
#                     <li>Created: #{ticket.long_timestamp}</li>
#                     <li>Office: #{ticket.ticket_office_name}</li>
#                     <li>Open: #{ticket.open}</li>
#                     <li>Service Date: #{ticket.service_date}</li>
#                 </ul>
#                 <p>View the ticket <a href=#{ticket_link}>here</a>.
#                 <p>Mark task complete <a href=#{complete_ticket_link}>here</a>.</p>
#             "
#         }
#         Meteor.call 'send_email', mail_fields
