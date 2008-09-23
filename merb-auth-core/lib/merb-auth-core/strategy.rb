class Authentication
  cattr_reader   :strategies, :default_strategy_order
  @@strategies, @@default_strategy_order = [], []
  
  def self.default_strategy_order=(*order)
    order = order.flatten
    bad = order.select{|s| !s.ancestors.include?(Strategy)}
    raise ArgumentError, "#{bad.join(",")} do not inherit from Authentication::Strategy" unless bad.empty?
    @@default_strategy_order = order
  end
  
  class Strategy
    attr_accessor :request
    
    class << self
      def inherited(klass)
        Authentication.strategies << klass
        Authentication.default_strategy_order << klass
      end
    
      def before(strategy)
        order = Authentication.default_strategy_order
        order.delete(self)
        index = order.index(strategy)
        order.insert(index,self)
      end
    
      def after(strategy)
        order = Authentication.default_strategy_order
        order.delete(self)
        index = order.index(strategy)
        index == order.size ? order << self : order.insert(index + 1, self)
      end
    
      def is_abstract?
        !!@_abstract
      end
      
      def is_abstract!
        @_abstract = true
      end
    end # End class << self
    
    def initialize(request)
      @request = request
    end
    
    def params
      request.params
    end
    
    def cookies
      request.cookies
    end
    
    # This is the method that is called as the test for authentication
    def run!
      raise NotImplemented
    end
    
    # Overwrite this method to scope a strategy to a particular user type
    # you can use this with inheritance for example to try the same strategy
    # on different user types
    # For example.  If Authentication.default_user_class is Customer
    # and you have a PasswordStrategy, you can subclass the PasswordStrategy
    # and change this method to return Staff.  So if Customer fails, it 
    # will try to authenticate as Staff.
    def user_class
      Authentication.default_user_class
    end
      
  end # Strategy
end # Authentication