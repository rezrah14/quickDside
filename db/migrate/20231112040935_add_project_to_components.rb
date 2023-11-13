class AddProjectToComponents < ActiveRecord::Migration[7.0]
  def change
    add_reference :components, :project, null: false, foreign_key: true
  end
end
