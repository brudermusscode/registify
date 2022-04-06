class AddPolymorphicToListItems < ActiveRecord::Migration[7.0]
  def change
    remove_column :list_items, :user_id

    # add a polymorphic reference to the creator of an item of a list
    add_reference :list_items, :creator, polymorphic: true
  end
end
