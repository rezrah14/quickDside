class ApplicationMailer < ActionMailer::Base
  default from: ENV["NO_REPLY_QUICKDSIDE_EMAIL"]
  layout "mailer"
end
