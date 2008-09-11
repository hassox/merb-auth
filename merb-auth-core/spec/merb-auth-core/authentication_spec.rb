require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe "Authentication Session" do
    
  before(:each) do
    @session_class = Merb::CookieSession
    @session = @session_class.generate
  end

  describe "module methods" do
    before(:each) do
      @m = mock("mock")
      clear_strategies!
    end
    
    after(:all) do
      clear_strategies!
    end
    
    describe "store_user" do
      it{@session.authentication.should respond_to(:store_user)}
      
      it "should raise a NotImplemented error by default" do
        pending "How to spec this when we need to overwrite it for the specs to work?"
        lambda do
          @session.authentication.store_user("THE USER")
        end.should raise_error(Authentication::NotImplemented)
      end
    end
    
    describe "fetch_user" do
      it{@session.authentication.should respond_to(:fetch_user)}
      
      it "should raise a NotImplemented error by defualt" do
        pending "How to spec this when we need to overwrite it for the specs to work?"
        lambda do 
          @session.authentication.fetch_user
        end.should raise_error(Authentication::NotImplemented)
      end
    end
  end
  
  describe "error_message" do
    
    before(:each) do
      @controller = Users.new(fake_request)
      @auth = Authentication.new(@controller.session)
    end
    
    it "should be 'Could not log in' by default" do
      @auth.error_message.should == "Could not log in"
    end
    
    it "should allow a user to set the error message" do
      @auth.error_message = "No You Don't"
      @auth.error_message.should == "No You Don't"
    end
  end
  
  describe "user" do
    it "should call fetch_user with the session contents to load the user" do
      @session[:user] = 42
      @session.authentication.should_receive(:fetch_user).with(42)
      @session.user
    end
    
    it "should set the @user instance variable" do
      @session[:user] = 42
      @session.authentication.should_receive(:fetch_user).and_return("THE USER")
      @session.user
      @session.authentication.assigns(:user).should == "THE USER"
    end
    
    it "should cache the user in an instance variable" do
      @session[:user] = 42
      @session.authentication.should_receive(:fetch_user).once.and_return("THE USER")
      @session.user
      @session.authentication.assigns(:user).should == "THE USER"
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
      @session.authentication.stub!(:fetch_user).and_return(@user)
    end
    
    it "should call store_user on the session to get the value to store in the session" do
      @session.authentication.should_receive(:store_user).with(@user)
      @session.user = @user
    end
    
    it "should set the instance variable to nil if the return of store_user is nil" do
      @session.authentication.should_receive(:store_user).and_return(nil)
      @session.user = @user
      @session.user.should be_nil
    end
    
    it "should set the instance varaible to nil if the return of store_user is false" do
      @session.authentication.should_receive(:store_user).and_return(false)
      @session.user = @user
      @session.user.should be_nil
    end
    
    it "should set the instance variable to the value of user if store_user is not nil or false" do
      @session.authentication.should_receive(:store_user).and_return(42)
      @session.user = @user
      @session.user.should == @user
      @session[:user].should == 42
    end
  end
  
  describe "abandon!" do
    
    before(:each) do
      @user = mock("user")
      @session.authentication.stub!(:fetch_user).and_return(@user)
      @session.authentication.stub!(:store_user).and_return(42)
      @session[:user] = 42
      @session.user
    end
    
    it "should delete the session" do
      @session.should_receive(:clear)
      @session.abandon!
    end
    
    it "should not have a user after it is abandoned" do
      @session.user.should == @user
      @session.abandon!
      @session.user.should be_nil
    end
  end
  
  describe "Authentication" do
    it "Should be hookable" do
      Authentication.should include(Extlib::Hook)
    end
    
  end
  
  describe "#authenticate" do
    
    before(:all) do
      clear_strategies!
    end
    
    after(:all) do
      clear_strategies!
    end
    
    before(:each) do
      class Sone < Authentication::Strategy
        def run!
        end
      end
      class Stwo < Authentication::Strategy
        def run!
        end
      end
      class Sthree < Authentication::Strategy
        def run!
          "WINNA"
        end
      end
      class Sfour < Authentication::Strategy
        is_abstract!
        
        def run!
          "BAD"
        end
      end
      
      Sfour.should_not_receive(:run!)
      @controller = Users.new(fake_request)
      @auth = Authentication.new(@controller.session)
      Authentication.stub!(:new).and_return(@auth)
    end
    
    it "should execute the strategies in the default order" do
      s1 = mock("s1")
      s2 = mock("s2")
      Sone.should_receive(:new).with(@controller).and_return(s1)
      Stwo.should_receive(:new).with(@controller).and_return(s2)
      s1.should_receive(:run!).ordered.and_return(nil)
      s2.should_receive(:run!).ordered.and_return("WIN")
      @auth.authenticate!(@controller)
    end
    
    it "should run the strategeis until if finds a non nil non false" do
      s1 = mock("s1")
      s2 = mock("s2")
      s3 = mock("s3")
      Sone.should_receive(:new).with(@controller).and_return(s1)
      Stwo.should_receive(:new).with(@controller).and_return(s2)
      Sthree.should_receive(:new).with(@controller).and_return(s3)
      s1.should_receive(:run!).ordered.and_return(nil)
      s2.should_receive(:run!).ordered.and_return(false)
      s3.should_receive(:run!).ordered.and_return("WIN")
      @auth.authenticate!(@controller)
    end
    
    it "should raise an Unauthenticated exception if no 'user' is found" do
      s3 = mock("s3")
      Sthree.stub!(:new).and_return(s3)
      s3.should_receive(:run!).and_return(nil)
      lambda do
        @auth.authenticate!(@controller)
      end.should raise_error(Merb::Controller::Unauthenticated)
    end
    
    it "should store the user into the session if one is found" do
      @auth.should_receive(:user=).with("WINNA")
      @auth.authenticate!(@controller)
    end
    
    it "should use the Authentiation#error_message as the error message" do
      @auth.should_receive(:error_message).and_return("BAD BAD BAD")
      s3 = mock("s3", :null_object => true)
      s3.stub!(:run!).and_return(false)
      Sthree.stub!(:new).and_return(s3)
      lambda do
        @auth.authenticate!(@controller)
      end.should raise_error(Merb::Controller::Unauthenticated, "BAD BAD BAD")
    end
    
    it "should execute the strategies as passed into the authenticate! method" do
      m1 = mock("strategy 1", :null_object => true)
      m2 = mock("strategy 2", :null_object => true)
      m1.stub!(:is_abstract?).and_return(false)
      m2.stub!(:is_abstract?).and_return(false)
      m1.should_receive(:new).and_return(m1)
      m2.should_receive(:new).and_return(m2)
      m2.should_receive(:run!).ordered
      m1.should_receive(:run!).ordered.and_return("WINNA")
      @auth.authenticate!(@controller, m2, m1)
    end
    
  end
  
  describe "default_user_class" do
    it "should have User as the default user class if requested" do
      Authentication.default_user_class.should == User
    end  
  end

end