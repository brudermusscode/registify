class RemoveColumnsFromLists < ActiveRecord::Migration[7.0]
  def change
    remove_column :lists, :listable_type
    remove_column :lists, :listable_id
  end
end
