require 'merb-auth-more/strategies/abstract_password'
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
        include Merb::AuthenticationMixin
        
        def run!
          if basic_authentication.provided?
            basic_authentication.authenticate do |login, password|
              user = user_class.authenticate(login, password) 
              unless user
                basic_authentication.request!
                throw(:halt, "Login Required")
              end
              user
            end
          end
        end
        
        
        
        # Need to overwrite this method so that we can pass in the request instead of a the strategy
        # which is what the mixin would do.
        def basic_authentication(realm = "Application", &authenticator)
          @_basic_authentication ||= BasicAuthentication.new(FakeController.new(request), realm, &authenticator)
        end
        
        private
        class FakeController < Struct.new(:request); end
        
      end # BasicAuth
    end # Password
  end # Strategies
end # Authentication