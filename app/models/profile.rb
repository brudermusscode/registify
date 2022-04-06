class Profile < ApplicationRecord
  belongs_to :owner, polymorphic: true
end
