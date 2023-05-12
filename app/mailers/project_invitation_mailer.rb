class ProjectInvitationMailer < ApplicationMailer
  def invitation_email(invitation, token)
    @invitation = invitation
    @first_name = invitation.first_name
    @last_name = invitation.last_name
    @project = invitation.project
    @inviter = invitation.inviter
    @invitee_email = invitation.email
    @token = token

    mail(to: @invitee_email, subject: 'You have been invited to join a project on QuickD$ide', from: ENV["NO_REPLY_QUICKDSIDE_EMAIL"])
  end
end
