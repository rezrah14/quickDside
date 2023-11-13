class UpdateStartDateDefaultInProjects < ActiveRecord::Migration[7.0]
  def change
    change_column_default :projects, :start_date, from: nil, to: -> { "CURRENT_DATE" }
  end
end
