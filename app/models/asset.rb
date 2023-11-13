class Asset < ApplicationRecord
  enum asset_type: { upstream: 0, downstream: 1 }
  validates :name, presence: true
  belongs_to :project
  has_and_belongs_to_many :tags
end
