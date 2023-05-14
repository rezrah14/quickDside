class UserMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def verification_email(user)
    @user = user
    @verification_url = verify_email_url(token: @user.verification_token)
    mail(to: @user.email, subject: 'Verify your email address')
  end
end
