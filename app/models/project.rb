class Project < ApplicationRecord
  include AccessLevels

  belongs_to :owner, class_name: "User"
  has_many :project_users, class_name: 'ProjectUser', dependent: :destroy
  has_many :users, through: :project_users
  validates :title, presence: true, length: { minimum: 6, maximum: 100 }

  def admins
    project_users.where(access_level: ProjectUser.access_levels[:administrator]).map(&:user)
  end

  def all_users
    # Get all associated users through the project_users association
    users = project_users.map(&:user)

    # Include the owner of the project if they are not already in the list
    users << owner unless users.include?(owner)

    # Return the list of unique users
    users.uniq
  end

  def invite_user(email, access_level)
    user = User.find_by(email: email.downcase)
    if user.present?
      project_users.create(user: user, access_level: access_level.to_sym)
    end
  end
end