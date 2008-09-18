require 'merb-auth-core/strategies/abstract_password'
# This strategy uses a login  and password parameter.
# Set these parameter names via the #password_param and #login_param methods on
# this strategy
#
# Required Methods:
# <User>.authenticate(login_param, password_param)
#
# Required fields:
# none
class Authentication
  module Strategies
    module Password
      class Form < Base
        
        def run!
          if params[login_param] && params[password_param]
            user_class.authenticate(params[login_param], params[password_param])
          end
        end # run!
        
      end # Form
    end # Password
  end # Strategies
end # Authentication