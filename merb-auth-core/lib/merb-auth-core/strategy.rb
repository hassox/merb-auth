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
    attr_accessor :controller
    
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
    
      def run!
        raise NotImplemented
      end
    end # End class << self
    
    def initialize(controller)
      @controller = controller
    end
    
    # This is the method that is called as the test for authentication
    def run!
      raise NotImplemented
    end
      
  end # Strategy
end # Authentication