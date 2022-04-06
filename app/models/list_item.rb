class ListItem < ApplicationRecord
  # belongings
  belongs_to :list, touch: true
  belongs_to :creator, polymorphic: true

  # validations
  validates :text, presence: true

  def my_list_item?(user_obj)
    creator == user_obj
  end
end
