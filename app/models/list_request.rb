class ListRequest < ApplicationRecord
  # belongings
  belongs_to :list
  belongs_to :requester, polymorphic: true
end
