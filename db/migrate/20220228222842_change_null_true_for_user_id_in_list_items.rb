class ChangeNullTrueForUserIdInListItems < ActiveRecord::Migration[7.0]
  def change
    change_column_null :list_items, :user_id, true
  end
end
