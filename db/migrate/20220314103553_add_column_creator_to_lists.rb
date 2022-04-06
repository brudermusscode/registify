class AddColumnCreatorToLists < ActiveRecord::Migration[7.0]
  def change
    add_reference :lists, :creator, polymorphic: true
  end
end
