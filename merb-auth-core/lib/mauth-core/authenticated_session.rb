# 
# Mixin for the Merb::DataMapperSession which provides for authentication
# 
module Authentication
  class DuplicateStrategy < Exception; end
  class MissingStrategy < Exception; end
  class NotImplemented < Exception; end
  
  @@login_strategies = StrategyContainer.new 

  def self.login_strategies
    @@login_strategies
  end
  
  module Session
    
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.send(:extend,  ClassMethods)
    end
    
    module ClassMethods    
    end # ClassMethods
    
    module InstanceMethods
      
      def _authentication_manager
        @_authentication_manager ||= Authentication::Manager.new(self)
      end
      
      def authenticated?
        _authentication_manager.authenticated?
      end
      
      def authenticate(controller)
        _authentication_manager.authenticate(controller)
      end
      
      def user
        _authentication_manager.user
      end
      
      def user=(the_user)
        _authentication_manager.user = the_user
      end
      
      def abandon!
        _authentication_manager.abandon!
      end
      
    end # InstanceMethods
    
  end # Session
end