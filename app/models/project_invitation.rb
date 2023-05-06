class ProjectInvitation < ApplicationRecord
  include AccessLevels

  belongs_to :project
  belongs_to :inviter, class_name: 'User'
  belongs_to :invitee, class_name: 'User', optional: true

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true
  validates :last_name, presence: true

  def self.generate_token
    SecureRandom.urlsafe_base64
  end

  def send_invitation_email
    token = self.class.generate_token
    self.update(token: token)

    ProjectInvitationMailer.invitation_email(self, token).deliver_now
  end

end
