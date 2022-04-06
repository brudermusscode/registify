class Admin < ApplicationRecord
  include Profilize
  include Lists

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, authentication_keys: [:login]

  before_destroy :last_admin?

  # define a new attribute writer which sets the required attribute for logging into an admin account
  # to login, instead of email which will eventually [...]
  attr_writer :login

  # [...] require either the username or the email of an admin
  def login
    @login || username || email
  end

  def last_admin?
    raise 'One admin should remain' if Admin.count < 2
  end

  # copied from devise's github
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(
        ['lower(username) = :value OR lower(email) = :value',
         { value: login.downcase }]
      ).first
    elsif conditions.key?(:username) || conditions.key?(:email)
      where(conditions.to_h).first
    end
  end
end
