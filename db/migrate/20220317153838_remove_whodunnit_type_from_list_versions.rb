class RemoveWhodunnitTypeFromListVersions < ActiveRecord::Migration[7.0]
  def change
    remove_column :list_versions, :whodunnit_type, :string
  end
end
