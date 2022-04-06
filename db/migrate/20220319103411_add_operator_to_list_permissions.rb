class AddOperatorToListPermissions < ActiveRecord::Migration[7.0]
  def change
    add_reference :list_permissions, :operator, polymorphic: true, index: true

    ListPermission.all.each do |perm|
      perm.operator = User.find perm.user_id
      perm.save
    end

    remove_column :list_permissions, :user_id, :string
    change_column_null :list_permissions, :operator_type, false
    change_column_null :list_permissions, :operator_id, false
  end
end
