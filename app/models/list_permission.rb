class ListPermission < ApplicationRecord
  after_create :delete_left_over_list_requests

  # belongings
  belongs_to :operator, polymorphic: true
  belongs_to :list

  # if permissions were created through a request, delete the request
  def delete_left_over_list_requests
    @user = operator
    @list = list

    ListRequest.where(requester: @user, list: @list).destroy_all
  end
end
