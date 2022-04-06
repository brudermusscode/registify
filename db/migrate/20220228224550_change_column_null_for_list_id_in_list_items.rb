class ChangeColumnNullForListIdInListItems < ActiveRecord::Migration[7.0]
  def change
    change_column_null :list_items, :list_id, true
  end
end
