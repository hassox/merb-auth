require "digest/sha1"
class Authentication
  module Mixins
    # This mixin provides basic salted user password encryption.
    # 
    # Added properties:
    #  :crypted_password, String
    #  :salt,             String
    #
    # To use it simply require it and include it into your user class.
    #
    # class User
    #   include Authentication::Mixins::SaltedUser
    #
    # end
    #
    module SaltedUser
      
      def self.included(base)
        base.class_eval do 
          attr_accessor :password, :password_confirmation
          
          include Authentication::Mixins::SaltedUser::InstanceMethods
          extend  Authentication::Mixins::SaltedUser::ClassMethods
          
          if defined?(DataMapper) && DataMapper::Resource > self
            extend(Authentication::Mixins::SaltedUser::DMClassMethods)
          elsif defined?(ActiveRecord) && ancestors.include?(ActiveRecord::Base)
            extend(Authentication::Mixins::SaltedUser::ARClassMethods)
          end
          
        end # base.class_eval
      end # self.included
      
      
      module ClassMethods
        # Encrypts some data with the salt.
        def encrypt(password, salt)
          Digest::SHA1.hexdigest("--#{salt}--#{password}--")
        end
      end
      
      module DMClassMethods
        def self.extended(base)
          base.class_eval do
            
            property :crypted_password,           String
            property :salt,                       String
            
            validates_present        :password, :if => proc{|m| m.password_required?}
            validates_is_confirmed   :password, :if => proc{|m| m.password_required?}
            
            before :save,   :encrypt_password
          end # base.class_eval
        end # self.extended
        
        def authenticate(login, password)
          @u = first(Authentication::Strategies::Basic::Base.login_param => login)
          @u && @u.authenticated?(password) ? @u : nil
        end
      end # DMClassMethods
      
      module ARClassMethods
        
        def self.extended(base)
          base.class_eval do
            
            validates_presence_of     :password,                   :if => :password_required?
            validates_presence_of     :password_confirmation,      :if => :password_required?
            validates_confirmation_of :password,                   :if => :password_required?
            
            before_save :encrypt_password
          end # base.class_eval 
        end # self.extended
        
        def authenticate(login, password)
          @u = find(:first, Authentication::Strategies::Basic::Base.login_param => login)
          @u && @u.authenticated?(password) ? @u : nil
        end
      end # ARClassMethods
      
      module InstanceMethods
        def authenticated?(password)
          crypted_password == encrypt(password)
        end
        
        def encrypt(password)
          self.class.encrypt(password, salt)
        end
        
        def password_required?
          crypted_password.blank? || !password.blank?
        end
        
        def encrypt_password
          return if password.blank?
          self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{Authentication::Strategies::Basic::Base.login_param}--") if new_record?
          self.crypted_password = encrypt(password)
        end
        
      end # InstanceMethods
      
    end # SaltedUser    
  end # Mixins
end # Authentication

