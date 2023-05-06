class CreateProjectInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :project_invitations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.string :email, null: false
      t.integer :access_level, null: false, default: 0
      t.timestamps
    end
  end
end
