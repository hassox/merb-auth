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
end # Authentication3