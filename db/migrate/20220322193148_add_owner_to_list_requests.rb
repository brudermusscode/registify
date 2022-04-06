class AddOwnerToListRequests < ActiveRecord::Migration[7.0]
  def change
    add_reference :list_requests, :requester, polymorphic: true, index: true

    ListRequest.all.each do |list_request|
      list_request.requester = User.find list_request.user_id
      list_request.save
    end

    remove_column :list_requests, :user_id, :integer

    change_column_null :list_requests, :requester_type, false
    change_column_null :list_requests, :requester_id, false
  end
end
