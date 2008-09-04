class Authentication
  module Session
  
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.send(:extend,  ClassMethods)
    end
  
    module ClassMethods    
    end # ClassMethods
  
    module InstanceMethods
    
      def authentication
        @authentication ||= Authentication.new(self)
      end
    
      def authenticated?
        authentication.authenticated?
      end
    
      def authenticate!(controller, *rest)
        authentication.authenticate!(controller, *rest)
      end
    
      def user
        authentication.user
      end
    
      def user=(the_user)
        authentication.user = the_user
      end
    
      def abandon!
        authentication.abandon!
      end
    
    end # InstanceMethods
  
  end # Session
end