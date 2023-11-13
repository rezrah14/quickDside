class CreateTimeSeriesAttributes < ActiveRecord::Migration[7.0]
  def change
    create_table :time_series_attributes do |t|
      t.string :name
      t.integer :interpolation_model
      t.string :unit

      t.timestamps
    end
  end
end
