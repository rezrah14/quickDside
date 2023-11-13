class TimeSeriesDataPoint < ApplicationRecord
  belongs_to :time_series_attribute

  validates :date, presence: true
  validates :value, presence: true
  validates :value, format: { with: /\A\d+(\.\d+)?\z/, message: "must be a number" }

end
