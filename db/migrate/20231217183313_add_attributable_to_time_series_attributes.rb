class AddAttributableToTimeSeriesAttributes < ActiveRecord::Migration[7.0]
  def change
    add_reference :time_series_attributes, :attributable, polymorphic: true, null: false
  end
end
