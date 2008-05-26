require 'digest/sha1'
begin
  require File.join(File.dirname(__FILE__), '..', '..', "lib", "authenticated_system", "authenticated_dependencies")
rescue 
  nil
end
class User < ActiveRecord::Base
  include AuthenticatedSystem::Model
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password
  before_create :make_activation_code
  after_create :send_signup_notification
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation
  
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
    UserMailer.dispatch_and_deliver(  :activation_notification,
                                  {   :from => User::EMAIL_FROM,
                                      :to   => self.email,
                                      :subject => User::ACTIVATE_MAIL_SUBJECT },

                                      :user => self )

  end

  def send_signup_notification
    UserMailer.dispatch_and_deliver(
        :signup_notification,
      { :from => User::EMAIL_FROM,
        :to  => self.email,
        :subject => User::SIGNUP_MAIL_SUBJECT },
        :user => self        
    )
  end

end
