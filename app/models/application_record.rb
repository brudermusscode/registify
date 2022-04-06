class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # scopes
  scope :order_by_updates, -> { order(updated_at: :desc) }
end
