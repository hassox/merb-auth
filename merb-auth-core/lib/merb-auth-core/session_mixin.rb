class Authentication
  module Session
  
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.send(:extend,  ClassMethods)
    end
  
    module ClassMethods    
    end # ClassMethods
  
    module InstanceMethods
    
      def _authentication
        @_authentication ||= Authentication.new(self)
      end
    
      def authenticated?
        _authentication.authenticated?
      end
    
      def authenticate!(controller)
        _authentication.authenticate!(controller)
      end
    
      def user
        _authentication.user
      end
    
      def user=(the_user)
        _authentication.user = the_user
      end
    
      def abandon!
        _authentication.abandon!
      end
    
    end # InstanceMethods
  
  end # Session
end