class AddInviterIdToProjectInvitations < ActiveRecord::Migration[7.0]
  def change
    add_column :project_invitations, :inviter_id, :integer
  end
end
