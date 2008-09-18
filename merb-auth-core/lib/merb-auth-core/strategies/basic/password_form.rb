require 'merb-auth-core/strategies/abstract_password'
# This strategy uses a login  and password parameter.
#
# Overwrite the :password_param, and :login_param
# to return the name of the field (on the form) that you're using the 
# login with.  These can be strings or symbols
#
# == Required
#
# === Methods
# <User>.authenticate(login_param, password_param)
#
class Authentication
  module Strategies
    module Basic
      class Form < Base
        
        def run!
          if params[login_param] && params[password_param]
            user = user_class.authenticate(params[login_param], params[password_param])
            if !user
              controller.session.authentication.errors.clear!
              controller.session.authentication.errors.add(:login, 'Username or password were incorrect')
            end
            user
          end
        end # run!
        
      end # Form
    end # Password
  end # Strategies
end # Authentication