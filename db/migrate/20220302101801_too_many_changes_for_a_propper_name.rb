class TooManyChangesForAPropperName < ActiveRecord::Migration[7.0]
  def change
    remove_column :lists, :user_id
    add_reference :lists, :ownable, polymorphic: true
  end
end
