class AddFreedAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :freed, :datetime, null: true, default: nil
  end
end
