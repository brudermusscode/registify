class AddOwnableToListItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :list_items, :ownable, polymorphic: true
  end
end
