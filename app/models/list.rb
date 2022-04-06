class List < ApplicationRecord
  has_paper_trail versions: { class_name: 'ListVersion' },
                  on: %i[create update touch]
  after_destroy :destroy_versions!

  # create a permission entry for the owner for its own list
  after_create :create_permission_for_owner

  # belongings
  belongs_to :ownable, polymorphic: true
  belongs_to :creator, polymorphic: true

  # has in it
  has_many :list_items, dependent: :destroy
  has_many :list_permissions, dependent: :destroy
  has_many :list_requests, dependent: :destroy
  has_many :list_invitations, dependent: :destroy

  # validations
  validates :name, presence: true

  # scopes
  scope :of_admins, -> { where(ownable_type: 'Admin') }
  scope :of_users, -> { where(ownable_type: 'User') }
  scope :of, ->(owner) { where(ownable: owner) }

  def destroy_versions!
    versions.destroy_all
  end

  def requested_permission?(session)
    list_requests.where(requester: session).first
  end

  def my_request(session)
    requested_permission?(session)
  end

  def create_permission_for_owner
    list_permissions.create! operator: ownable
  end
end
