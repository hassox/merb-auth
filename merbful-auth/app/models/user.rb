require "digest/sha2"

begin
  require File.join(File.dirname(__FILE__), '..', '..', "lib", "authenticated_system", "authenticated_dependencies")
rescue 
  nil
end

class User
  include AuthenticatedSystem::Model

  # Virtual attribute for the unencrypted password
  attr_accessor :password
  attr_accessor :attributes
  class << self
    @attributes = {}
  end
  #before_save   :encrypt_password
  #before_create :make_activation_code
  #after_create  :send_signup_notification
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  #attr_accessible :login, :email, :password, :password_confirmation
  def self.[](value)
    attributes[value]
  end
  
  def login=(login_name)
    self[:login] = login_name.downcase unless login_name.nil?
  end

  EMAIL_FROM = "info@mysite.com"
  SIGNUP_MAIL_SUBJECT = "Welcome to MYSITE.  Please activate your account."
  ACTIVATE_MAIL_SUBJECT = "Welcome to MYSITE"

  # Activates the user in the database
  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save

    # send mail for activation
    UserMailer.dispatch_and_deliver(
    :activation_notification,
    { :from => User::EMAIL_FROM, :to   => self.email, :subject => User::ACTIVATE_MAIL_SUBJECT  },
    :user => self
    )

  end

  def send_signup_notification
    UserMailer.dispatch_and_deliver(
    :signup_notification,
    { :from => User::EMAIL_FROM, :to  => self.email, :subject => User::SIGNUP_MAIL_SUBJECT },
    :user => self
    )
  end

end

