require 'sendgrid-ruby'
include SendGrid

def send_email(to_email, subject, content_value)
  from = Email.new(email: 'edflix.management@gmail.com')
  to = Email.new(email: to_email)
  content = Content.new(type: 'text/plain', value: content_value)
  mail = Mail.new(from, subject, to, content)

  sg = SendGrid::API.new(api_key: 'xxxxxx') # Replace with your SendGrid API key
  response = sg.client.mail._('send').post(request_body: mail.to_json)
  puts response.status_code
  puts response.body
  puts response.headers
end
