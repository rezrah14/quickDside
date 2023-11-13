class AddTimeIntervalsToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :time_intervals, :jsonb, default: []
  end
end
