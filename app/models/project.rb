class Project < ApplicationRecord
  include AccessLevels

  belongs_to :owner, class_name: "User"
  has_many :project_users, class_name: 'ProjectUser', dependent: :destroy
  has_many :assets, dependent: :destroy
  has_many :users, through: :project_users
  has_many :components, dependent: :destroy
  attribute :start_date, :date
  attribute :time_intervals, :json


  # validations
  validates :length, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 500 }
  validates :monthly_resolution_end_year, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: :length }
  validates :start_date, presence: true
  validates :title, presence: true, length: { minimum: 6, maximum: 100 }

  # Callbacks
  before_save :generate_time_interval

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

  private

  def generate_time_interval
    start_year = start_date.year
    end_year = start_year + length - 1
  
    # Clear existing time intervals for the project
    self.time_intervals = []
  
    current_year = start_year
    while current_year <= end_year
      if current_year == start_year
        # For the first year, start from the start_date instead of January
        self.time_intervals << start_date.to_s
        self.time_intervals += generate_monthly_interval(start_year).drop(start_date.month).map(&:to_s)
      elsif current_year < start_year + monthly_resolution_end_year
        self.time_intervals += generate_monthly_interval(current_year).map(&:to_s)
      else
        self.time_intervals << Date.new(current_year, 1, 1).to_s
      end
  
      current_year += 1
    end
  end

  def generate_monthly_interval(year)
    (1..12).map { |month| Date.new(year, month, 1) }
  end

end