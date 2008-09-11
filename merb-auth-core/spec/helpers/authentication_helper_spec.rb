require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe "Merb::AuthenticationHelper" do
  
  class ControllerMock < Merb::Controller
    before :ensure_authenticated
  end
  
  before(:each) do
    @controller = ControllerMock.new(fake_request)
    @session = mock("session")
    @controller.stub!(:session).and_return(@session)
    @session.stub!(:authenticated?).and_return(true)
  end
  
  it "should not raise and Unauthenticated error" do
    lambda do
      @controller.send(:ensure_authenticated)
    end.should_not raise_error(Merb::Controller::Unauthenticated)
  end
  
  it "should raise an Unauthenticated error" do
    @controller = ControllerMock.new(Merb::Request.new({}))
    lambda do
      @controller.send(:ensure_authenticated)
    end.should raise_error(Merb::Controller::Unauthenticated)
  end
  
  it "should run the authentication when testing if it is authenticated" do
    @controller = ControllerMock.new(fake_request)
    @controller.session.should_receive(:user).and_return(nil, "WINNA")
    @controller.session.authentication.should_receive(:authenticate!).with(@controller).and_return("WINNA")
    @controller.send(:ensure_authenticated)
  end
  
  it "should accept and execute the provided strategies" do
    # This allows using a before filter with specific arguments
    # before :ensure_authenticated, :with => [Authenticaiton::OAuth, Authentication::BasicAuth]
    M1 = mock("m1")
    M2 = mock("m2")
    M1.stub!(:new).and_return(M1)
    M2.stub!(:new).and_return(M2)
    M1.should_receive(:is_abstract?).and_return(false)
    M2.should_receive(:is_abstract?).and_return(false)
    M1.should_receive(:run!).ordered.and_return(false)
    M2.should_receive(:run!).ordered.and_return("WINNA")
    controller = ControllerMock.new(fake_request)
    controller.session.should_receive(:user).and_return(nil, "WINNA")
    controller.send(:ensure_authenticated, [M1, M2])
  end
  
end