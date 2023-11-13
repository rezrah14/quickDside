class Component < ApplicationRecord
  belongs_to :project
  has_one :time_series_attribute, as: :attributable, dependent: :destroy
  validates :name, :quantity_type, :unit_multiplier, :unit, :price_interpolation_model, :currency, presence: true

  after_create :create_price_time_series_attribute

  def add_price(date, price, currency)
    time_series_attribute.add_data(date, price, currency)
  end

  def get_price(requested_date, requested_currency)
    price_data = time_series_attribute.calculate_value(requested_date, requested_currency)
  end

  def delete_price(date)
    price_data = time_series_attribute.find_data(date)
    price_data.destroy if price_data.present?
  end

  def edit_price(date, new_price, currency)
    price_data = time_series_attribute.find_data(date)
    if price_data.present?
      price_data.update(price: new_price, currency: currency)
    end
  end

  private

  def create_price_time_series_attribute
    time_series_attribute = TimeSeriesAttribute.create(name: "#{name} Price")
    self.time_series_attribute = time_series_attribute
  end
end