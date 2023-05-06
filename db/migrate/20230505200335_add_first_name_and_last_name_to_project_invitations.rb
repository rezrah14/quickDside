class AddFirstNameAndLastNameToProjectInvitations < ActiveRecord::Migration[7.0]
  def change
    add_column :project_invitations, :first_name, :string
    add_column :project_invitations, :last_name, :string
  end
end
