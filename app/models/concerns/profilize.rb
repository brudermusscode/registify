module Profilize
  extend ActiveSupport::Concern

  included do
    validates :username,
              presence: true,
              uniqueness: { case_sensitive: false },
              format: {
                with: /^[a-zA-Z0-9_.]*$/,
                multiline: true
              }

    after_create :create_profile!

    has_one :profile, as: :owner, dependent: :destroy
  end

  # create a profile as soon as a new instance of this model is created
  def create_profile!
    Profile.create! owner: self
  end
end
