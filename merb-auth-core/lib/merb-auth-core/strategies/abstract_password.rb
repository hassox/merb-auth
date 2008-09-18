class Authentication
  module Strategies
    # To use the password strategies, it is expected that you will provide
    # an @authenticate@ method on your user class.  This should take two parameters
    # login, and password.  It should return nil or the user object.
    module Basic
      
      class Base < Authentication::Strategy
        is_abstract!
        
        # Overwrite this method to customize the field
        def password_param
          :password
        end
        
        # Overwrite this method to customize the field
        def login_param
          :login
        end
      end # Base      
    end # Password
  end # Strategies
end # Authentication