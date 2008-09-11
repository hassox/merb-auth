class Authentication
  module Strategies
    module Password
      class Form < Base
        
        def run!
          if params[login_field] && params[password_field]
            user_class.authenticate(params[login_field], params[password_field])
          end
        end # run!
        
      end # Form
    end # Password
  end # Strategies
end # Authentication3