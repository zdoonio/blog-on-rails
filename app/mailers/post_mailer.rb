class PostMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.post_mailer.new_post_notification.subject
  #
  def new_post_notification(post, email)
    @post = post


    mail to: email, subject: "WOW! New post on our blog!", from: "admin@blog.com"
  end
end
