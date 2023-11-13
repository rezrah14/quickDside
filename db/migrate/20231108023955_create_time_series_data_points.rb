class CreateTimeSeriesDataPoints < ActiveRecord::Migration[7.0]
  def change
    create_table :time_series_data_points do |t|
      t.references :time_series_attribute, null: false, foreign_key: true
      t.date :date
      t.decimal :value

      t.timestamps
    end
  end
end
