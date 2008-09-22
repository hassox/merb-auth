require 'merb-auth-core/strategies/abstract_password'
# This strategy is used with basic authentication in Merb.
#
# == Requirements
#
# == Methods
#   <User>.authenticate(login_field, password_field)
#
class Authentication
  module Strategies
    module Basic
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