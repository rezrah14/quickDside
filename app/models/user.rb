class User < ApplicationRecord
  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  has_many :owned_projects, class_name: "Project", foreign_key: "owner_id", dependent: :destroy

  # Add a column to store the verification token
  before_save { self.email = email.downcase }

  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { minimum: 3, maximum: 25 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { maximum: 105 },
                    format: { with: VALID_EMAIL_REGEX }

  has_secure_password
  phony_normalize :phone_number, default_country_code: 'US'

  def all_projects
    Project.joins(:project_users)
           .where('project_users.user_id = ?', id)
           .distinct
  end

  def generate_verification_token
    self.verification_token = SecureRandom.urlsafe_base64
  end

  def password_required?
    new_record? || password.present?
  end

  validates :password, confirmation: true
end
