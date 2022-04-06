class AddPolymorphicOwnerToProfile < ActiveRecord::Migration[7.0]
  def change
    add_reference :profiles, :owner, polymorphic: true, index: true

    Profile.all.each do |profile|
      profile.owner_id = User.find(profile.user_id).id
      profile.owner_type = 'User'
      profile.save
    end

    remove_column :profiles, :user_id

    change_column_null :profiles, :owner_type, false
    change_column_null :profiles, :owner_id, false
  end
end
