require "test_helper"

class TimeSeriesAttributeTest < ActiveSupport::TestCase
  test "adding data maintains order" do
    time_series_attribute = TimeSeriesAttribute.create(name: "Attribute 1", interpolation_model: :stepwise, unit: "unit")
    time_series_attribute.add_data(Date.today, 10, "unit")
    time_series_attribute.add_data(Date.today - 1, 5, "unit")

    assert_equal time_series_attribute.time_series_data_points.first.date, Date.today - 1
    assert_equal time_series_attribute.time_series_data_points.last.date, Date.today
  end

  test "linear interpolation calculates the correct value" do
    time_series_attribute = TimeSeriesAttribute.create(name: "Attribute 2", interpolation_model: :linear, unit: "unit")
    time_series_attribute.add_data(Date.today - 3, 10, "unit")
    time_series_attribute.add_data(Date.today, 31, "unit")
    result = time_series_attribute.calculate_value(Date.today - 2, "unit")
    assert_equal result.round, 17
  end

  test "stepwise interpolation returns the correct value" do
    time_series_attribute = TimeSeriesAttribute.create(name: "Attribute 3", interpolation_model: :stepwise, unit: "unit")
    time_series_attribute.add_data(Date.today - 3, 10, "unit")
    time_series_attribute.add_data(Date.today, 20, "unit")

    result = time_series_attribute.calculate_value(Date.today - 2, "unit")
    assert_equal result, 10
  end

end
