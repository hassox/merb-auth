require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe Authentication::Session do

  before(:all) do
    Merb::CookieSession.send(:include, Authentication::Session)
  end
    
  before(:each) do
    @session = Merb::CookieSession.new( "", "sekrit")    
  end

  def clear_strategies
    Authentication.login_strategies.clear!
  end

  describe "module methods" do
    before(:each) do
      @m = mock("mock")
      clear_strategies
    end
    
    after(:all) do
      clear_strategies
    end
    
    describe "login_strategies" do
      it "should provide access to these strategies" do
        Authentication.login_strategies.should be_a_kind_of(Authentication::StrategyContainer)
      end
    
      it "should allow adding a find strategy" do
        Authentication.login_strategies.add(:salted_login){ @m.salted_login }
        @m.should_receive(:salted_login)
        Authentication.login_strategies[:salted_login].call      
      end
    end # login_strategies
    
    describe "store_user" do
      it{@session._authentication_manager.should respond_to(:store_user)}
      
      it "should raise a NotImplemented error by default" do
        pending "How to spec this when we need to overwrite it for the specs to work?"
        lambda do
          @session._authentication_manager.store_user("THE USER")
        end.should raise_error(Authentication::NotImplemented)
      end
    end
    
    describe "fetch_user" do
      it{@session._authentication_manager.should respond_to(:fetch_user)}
      
      it "should raise a NotImplemented error by defualt" do
        pending "How to spec this when we need to overwrite it for the specs to work?"
        lambda do 
          @session._authentication_manager.fetch_user
        end.should raise_error(Authentication::NotImplemented)
      end
    end
  end

  describe "user" do
    it "should call fetch_user with the session contents to load the user" do
      @session[:user] = 42
      @session._authentication_manager.should_receive(:fetch_user).with(42)
      @session.user
    end
    
    it "should set the @user instance variable" do
      @session[:user] = 42
      @session._authentication_manager.should_receive(:fetch_user).and_return("THE USER")
      @session.user
      @session._authentication_manager.assigns(:user).should == "THE USER"
    end
    
    it "should cache the user in an instance variable" do
      @session[:user] = 42
      @session._authentication_manager.should_receive(:fetch_user).once.and_return("THE USER")
      @session.user
      @session._authentication_manager.assigns(:user).should == "THE USER"
      @session.user
    end
    
    it "should set the ivar to nil if the session is nil" do
      @session[:user] = nil
      @session.user.should be_nil
    end
    
  end
  
  describe "user=" do
    before(:each) do
      @user = mock("user")
      @session._authentication_manager.stub!(:fetch_user).and_return(@user)
    end
    
    it "should call store_user on the session to get the value to store in the session" do
      @session._authentication_manager.should_receive(:store_user).with(@user)
      @session.user = @user
    end
    
    it "should set the instance variable to nil if the return of store_user is nil" do
      @session._authentication_manager.should_receive(:store_user).and_return(nil)
      @session.user = @user
      @session.user.should be_nil
    end
    
    it "should set the instance varaible to nil if the return of store_user is false" do
      @session._authentication_manager.should_receive(:store_user).and_return(false)
      @session.user = @user
      @session.user.should be_nil
    end
    
    it "should set the instance variable to the value of user if store_user is not nil or false" do
      @session._authentication_manager.should_receive(:store_user).and_return(42)
      @session.user = @user
      @session.user.should == @user
      @session[:user].should == 42
    end
  end
  
  describe "abandon!" do
    
    before(:each) do
      @user = mock("user")
      @session._authentication_manager.stub!(:fetch_user).and_return(@user)
      @session._authentication_manager.stub!(:store_user).and_return(42)
      @session[:user] = 42
      @session.user
    end
    
    it "should delete the session" do
      @session.should_receive(:delete)
      @session.abandon!
    end
    
    it "should not have a user after it is abandoned" do
      @session.user.should == @user
      @session.abandon!
      @session.user.should be_nil
    end
  end

  describe "Authentication Manager" do
    it "Should be hookable" do
      Authentication::Manager.should include(Extlib::Hook)
    end
  end

end