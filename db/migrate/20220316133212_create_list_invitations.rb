class CreateListInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :list_invitations do |t|
      t.references :list, null: false, foreign_key: true
      t.string :token, null: false

      t.timestamps
    end
  end
end
