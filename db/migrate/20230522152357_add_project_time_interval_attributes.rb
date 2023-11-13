class AddProjectTimeIntervalAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :length, :integer, default: 100
    add_column :projects, :monthly_resolution_end_year, :integer, default: 1
    add_column :projects, :start_date, :date, default: Date.today
    add_column :projects, :time_interval, :date, array: true
  end
end
