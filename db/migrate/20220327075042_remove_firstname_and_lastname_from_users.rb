class RemoveFirstnameAndLastnameFromUsers < ActiveRecord::Migration[7.0]
  def change
    clms = %i[firstname lastname city street postcode]

    clms.each do |column|
      remove_column :users, column
      remove_column :admins, column
    end
  end
end
