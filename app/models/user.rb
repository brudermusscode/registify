class User < ApplicationRecord
  include Profilize
  include Lists

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, authentication_keys: [:login]

  # define a new attribute writer which sets the required attribute for logging into an admin account
  # to login, instead of email which will eventually [...]
  attr_writer :login

  # [...] require either the username or the email of an admin
  def login
    @login || username || email
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

  # unlock user if locked through login process
  def unlock!
    update(locked_at: nil)
    UserMailer.with(user: self).unlocked_account.deliver_now
  end

  # specify method for checking the locked state for a user
  def locked?
    locked_at?
  end

  # newly registered users need to be freed for sign in.
  # This is what this method does
  def free!
    update(freed_at: Time.now) if confirmed?
  end

  # specify a method for checking the free state for a user
  def freed?
    freed_at?
  end

  # de/-activation
  def toggle_active_state!
    if activated?
      update(approved_at: nil)
    else
      update(approved_at: Time.now)
    end
  end

  # specify a method for checking the active state for a user
  def activated?
    approved_at?
  end

  # require approved? and freed? method check for login
  def active_for_authentication?
    super && activated? && freed?
  end

  # set new message for accounts not being activated by an admin
  def inactive_message?
    approved? ? super : I18n.t('administration.users.flash.success.need_approval')
  end
end
