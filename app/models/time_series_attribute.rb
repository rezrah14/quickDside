class TimeSeriesAttribute < ApplicationRecord
  has_many :time_series_data_points, -> { order(date: :asc) }, dependent: :destroy

  enum interpolation_model: {
    stepwise: 0,
    linear: 1
  }

  validates :name, presence: true
  validates :interpolation_model, presence: true
  validates :unit, presence: true

  def add_data(date, value, unit)
    time_series_data_points.create(date: date, value: value)
  end

  def calculate_value(requested_date, requested_unit)
    return unless time_series_data_points.any?

    case interpolation_model.to_sym
    when :linear
      linear_interpolation(requested_date, requested_unit)
    when :stepwise
      stepwise_interpolation(requested_date, requested_unit)
    else
      raise "Unknown interpolation model"
    end
  end

  private

  def linear_interpolation(requested_date, requested_unit)
    return time_series_data_points.first.value if requested_date <= time_series_data_points.first.date
    return time_series_data_points.last.value if requested_date >= time_series_data_points.last.date
    relevant_data_points = time_series_data_points.where("date <= ?", requested_date)
    index = relevant_data_points.size
    lower_point = relevant_data_points[index - 1]
    upper_point = time_series_data_points[index]
    time_diff = (upper_point.date - lower_point.date).to_f
    value_diff = upper_point.value - lower_point.value
    time_ratio = (requested_date - lower_point.date).to_f / time_diff
    interpolated_value = lower_point.value + (value_diff * time_ratio)
    interpolated_value
  end

  def stepwise_interpolation(requested_date, requested_unit)
    last_before_requested = time_series_data_points.where("date <= ?", requested_date).last
    last_before_requested&.value
  end
end
