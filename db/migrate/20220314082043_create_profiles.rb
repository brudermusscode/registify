class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.timestamps
    end

    add_reference :profiles, :user
  end
end