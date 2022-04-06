class AddColumnsToLists < ActiveRecord::Migration[7.0]
  def change
    add_column :lists, :listable_type, :string
    add_column :lists, :listable_id, :integer
  end
end
