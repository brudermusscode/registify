class AddFirstnameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :street, :string
    add_column :users, :postcode, :integer
    add_column :users, :city, :string
    add_column :users, :born_at, :date
  end
end
