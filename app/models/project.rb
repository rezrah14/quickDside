class Project < ApplicationRecord
  validates :title, presence: true, length: { minimum: 6, maximum: 100 }
  validates :description, length: { minimum: 10, maximum: 500 }
end