class AddToAdmins < ActiveRecord::Migration[7.0]
  def change
    add_column :admins, :firstname, :string
    add_column :admins, :lastname, :string
    add_column :admins, :username, :string
    add_column :admins, :street, :string
    add_column :admins, :postcode, :integer
    add_column :admins, :city, :string
    add_column :admins, :born_at, :date
  end
end
