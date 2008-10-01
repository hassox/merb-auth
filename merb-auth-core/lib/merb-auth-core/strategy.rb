class Authentication
  cattr_reader   :strategies, :default_strategy_order
  @@strategies, @@default_strategy_order = [], []
  
  # Use this to set the default order of strategies 
  # if you need to in your application.  You don't need to use all avaiable strategies
  # in this array, but you may not include a strategy that has not yet been defined.
  # 
  # @params [Authentiation::Strategy,Authentication::Strategy]
  def self.default_strategy_order=(*order)
    order = order.flatten
    bad = order.select{|s| !s.ancestors.include?(Strategy)}
    raise ArgumentError, "#{bad.join(",")} do not inherit from Authentication::Strategy" unless bad.empty?
    @@default_strategy_order = order
  end
  
  # The Authentication::Strategy is where all the action happens in the merb-auth framework.
  # Inherit from this class to setup your own strategy.  The strategy will automatically
  # be placed in the default_strategy_order array, and will be included in the strategy runs.
  #
  # The strategy you implment should have a YourStrategy#run! method defined that returns
  #   1. A user object if authenticated
  #   2. nil if no authenticated user was found.
  #
  # === Example
  #
  #    class MyStrategy < Authentication::Strategy
  #      def run!
  #        u = User.get(params[:login])
  #        u if u.authentic?(params[:password])
  #      end
  #    end
  #
  #
  class Strategy
    attr_accessor :request
    
    class << self
      def inherited(klass)
        Authentication.strategies << klass
        Authentication.default_strategy_order << klass
      end
    
      # Use this to declare the strategy should run before another strategy
      def before(strategy)
        order = Authentication.default_strategy_order
        order.delete(self)
        index = order.index(strategy)
        order.insert(index,self)
      end
    
      # Use this to declare the strategy should run after another strategy
      def after(strategy)
        order = Authentication.default_strategy_order
        order.delete(self)
        index = order.index(strategy)
        index == order.size ? order << self : order.insert(index + 1, self)
      end
      
      # Mark a strategy as abstract.  This means that a strategy will not
      # ever be run as part of the authentication.  Instead this 
      # will be available to inherit from as a way to share code.
      # 
      # You could for example setup a strategy to check for a particular kind of login
      # and then have a subclass for each class type of user in your system.
      # i.e. Customer / Staff, Student / Staff etc
      def abstract!
        @abstract = true
      end
    
      # Asks is this strategy abstract. i.e. can it be run as part of the authentication
      def abstract?
        !!@abstract
      end
    
    end # End class << self
    
    def initialize(request)
      @request = request
    end
    
    # An alias to the request.params hash
    def params
      request.params
    end
    
    # An alials to the request.cookies hash
    def cookies
      request.cookies
    end
    
    # An alias to the request.session hash
    def session
      request.session
    end
    
    # This is the method that is called as the test for authentication and is where
    # you put your code.
    # 
    # You must overwrite this method in your strategy
    #
    # @api overwritable
    def run!
      raise NotImplemented
    end
    
    # Overwrite this method to scope a strategy to a particular user type
    # you can use this with inheritance for example to try the same strategy
    # on different user types
    #
    # By default, Authentication.user_class is used.  This method allows for 
    # particular strategies to deal with a different type of user class.
    #
    # For example.  If Authentication.user_class is Customer
    # and you have a PasswordStrategy, you can subclass the PasswordStrategy
    # and change this method to return Staff.  Giving you a PasswordStrategy strategy
    # for first Customer(s) and then Staff.  
    #
    # @api overwritable
    def user_class
      Authentication.user_class
    end
      
  end # Strategy
end # Authentication