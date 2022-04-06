class AddColumnUseCountToListInvitations < ActiveRecord::Migration[7.0]
  def change
    add_column :list_invitations, :use_count, :integer, null: false, default: 0
  end
end
