class AddWhodunnitType < ActiveRecord::Migration[7.0]
  def change
    add_column :list_versions, :whodunnit_type, :string, index: true
  end
end
