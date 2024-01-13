class Component < ApplicationRecord
  belongs_to :project
  has_one :time_series_attribute, as: :attributable, dependent: :destroy
  validates :name, :quantity_type, :unit, :unit_multiplier, :price_interpolation_model, :currency, presence: true
  validates :project_id, presence: true

  enum quantity_type: { mass: 0, volume: 1 }
  enum unit: { kg: 0, lb: 1, m3: 2, ft3: 3, bbl: 4 }
  enum unit_multiplier: { micro: 0, milli: 1, unit: 2, kilo: 3, mega: 4 }, _suffix: true, _default: :unit
  enum currency: { USD: 0, CAD: 1, GBP: 2, Euro: 3, yen: 4, yuan: 5 }
  enum price_interpolation_model: { stepwise: 0, linear: 1 }

  after_create :create_price_time_series_attribute

  def add_price(date, price, currency)
    time_series_attribute.add_data(date, price, currency)
  end

  def get_price(requested_date, requested_currency)
    price_data = time_series_attribute.calculate_value(requested_date, requested_currency)
  end

  private

  def create_price_time_series_attribute
    self.time_series_attribute = TimeSeriesAttribute.create(
      name: "#{name} Price",
      interpolation_model: price_interpolation_model,
      unit: unit
    )
  end

end