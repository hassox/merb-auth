require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe "Authentication::Strategy" do
    
  before(:all) do
    clear_strategies!
  end
  
  before(:each) do
    clear_strategies!
  end
  
  after(:all) do
    clear_strategies!
  end
  
  describe "adding a strategy" do
    it "should add a strategy" do
      class MyStrategy < Authentication::Strategy; end
      Authentication.strategies.should include(MyStrategy)
    end
    
    it "should keep track of the strategies" do
      class Sone < Authentication::Strategy; end
      class Stwo < Authentication::Strategy; end
      Authentication.strategies.should include(Sone, Stwo)
      Authentication.default_strategy_order.pop
      Authentication.strategies.should include(Sone, Stwo)
    end
    
    it "should add multiple strategies in order of decleration" do
      class Sone < Authentication::Strategy; end
      class Stwo < Authentication::Strategy; end
      Authentication.default_strategy_order.should == [Sone, Stwo]
    end
    
    it "should allow a strategy to be inserted _before_ another strategy in the default order" do
      class Sone < Authentication::Strategy; end
      class Stwo < Authentication::Strategy; end
      class AuthIntruder < Authentication::Strategy; before Stwo; end
      Authentication.strategies.should include(AuthIntruder, Stwo, Sone)
      Authentication.default_strategy_order.should == [Sone, AuthIntruder, Stwo]
    end
    
    it "should allow a strategy to be inserted _after_ another strategy in the default order" do
      class Sone < Authentication::Strategy; end
      class Stwo < Authentication::Strategy; end
      class AuthIntruder < Authentication::Strategy; after Sone; end
      Authentication.strategies.should include(AuthIntruder, Stwo, Sone)
      Authentication.default_strategy_order.should == [Sone, AuthIntruder, Stwo]
    end
  end
  
  describe "the default order" do
    it "should allow a user to overwrite the default order" do
      class Sone < Authentication::Strategy; end
      class Stwo < Authentication::Strategy; end
      Authentication.default_strategy_order = [Stwo]
      Authentication.default_strategy_order.should == [Stwo]
    end
    
    it "should get raise an error if any strategy is not an Authentication::Strategy" do
      class Sone < Authentication::Strategy; end
      class Stwo < Authentication::Strategy; end
      lambda do
        Authentication.default_strategy_order = [Stwo, String]
      end.should raise_error(ArgumentError)
    end
  end

  it "should raise a not implemented error if the run! method is not defined in the subclass" do
    class Sone < Authentication::Strategy; end
    lambda do
      Sone.new("controller").run!
    end.should raise_error(Authentication::NotImplemented)
  end
  
  it "should not raise an implemented error if the run! method is defined on the subclass" do
    class Sone < Authentication::Strategy; def run!; end; end
    lambda do
      Sone.new("controller").run!
    end.should_not raise_error(Authentication::NotImplemented)
  end
  
  describe "convinience methods" do
    
    before(:each) do
      class Sone < Authentication::Strategy; def run!; end; end 
      @controller = mock("controller")
      @strategy = Sone.new(@controller)
    end
    
    it "should provide a params helper that defers to the controller" do
      @controller.should_receive(:params).and_return("PARAMS")
      @strategy.params.should == "PARAMS"
    end
    
    it "should provide a cookies helper" do
      @controller.should_receive(:cookies).and_return("COOKIES")
      @strategy.cookies.should == "COOKIES"
    end
    
  end
  
  describe "#user_class" do
    
    # This allows you to scope a particular strategy to a particular user class object
    # By inheriting you can add multiple user types to the authentication process
    
    before(:each) do
      class Sone < Authentication::Strategy; def run!; end; end
      class Stwo < Sone; end
      
      class Mone < Authentication::Strategy
        def user_class; String; end
        def run!; end
      end
      class Mtwo < Mone; end
      
      @controller = mock("controller", :null_object => true)
    end
    
    it "should implement a user_class helper" do
      s = Sone.new(@controller)
      s.user_class.should == User
    end
    
    it "should defer to the Authentication.default_user_class if not over written" do
      Authentication.should_receive(:default_user_class).and_return(User)
      s = Sone.new(@controller)
      s.user_class
    end
    
    it "should inherit the user class from it's parent by default" do
      Authentication.should_receive(:default_user_class).and_return(User)
      s = Stwo.new(@controller)
      s.user_class.should == User
    end
    
    it "should inherit the user_class form it's parent when the parent defines a new one" do
      Authentication.should_not_receive(:default_user_class)
      m = Mtwo.new(@controller)
      m.user_class.should == String
    end
    
  end
  
end