class ProjectUser < ApplicationRecord
  include AccessLevels

  belongs_to :user
  belongs_to :project
end
