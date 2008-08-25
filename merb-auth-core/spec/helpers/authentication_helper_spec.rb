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
    @controller.setup_session
    lambda do
      @controller.send(:ensure_authenticated)
    end.should raise_error(Merb::Controller::Unauthenticated)
  end
  
end