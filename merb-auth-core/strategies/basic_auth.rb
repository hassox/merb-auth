require 'merb-auth-core/strategies/abstract_password'
# Required Methods:
# <User>.authenticate(login_field, password_field)
#
# Required fields:
# none
class Authentication
  module Strategies
    module Password
      class BasicAuth < Base
        
        def run!
          if controller.basic_authentication.provided?
            controller.basic_authentication.authenticate do |login, password|
              user = user_class.authenticate(login, password) 
              unless user
                controller.basic_authentication.request!
                throw(:halt, "Login Required")
              end
              user
            end
          end
        end
        
      end # BasicAuth
    end # Password
  end # Strategies
end # Authentication