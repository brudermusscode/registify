class ChangeColumnDefaultOfApprovedInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :approved_at, Time.now
  end
end
