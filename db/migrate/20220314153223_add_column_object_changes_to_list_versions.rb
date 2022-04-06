# This migration adds the optional `object_changes` column, in which PaperTrail
# will store the `changes` diff for each update event. See the readme for
# details.
class AddColumnObjectChangesToListVersions < ActiveRecord::Migration[7.0]
  # The largest text column available in all supported RDBMS.
  # See `create_versions.rb` for details.
  TEXT_BYTES = 1_073_741_823

  def change
    add_column :list_versions, :object_changes, :text, limit: TEXT_BYTES
  end
end
