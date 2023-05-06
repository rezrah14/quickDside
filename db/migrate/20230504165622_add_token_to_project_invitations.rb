class AddTokenToProjectInvitations < ActiveRecord::Migration[7.0]
  def change
    add_column :project_invitations, :token, :string
  end
end
