class ApplicationMailer < ActionMailer::Base
  default from: 'admin@blog.com'
  layout 'mailer'
end
