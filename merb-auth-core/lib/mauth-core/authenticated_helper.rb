module Merb
  class Controller::Unauthenticated < ControllerExceptions::Unauthorized; end
  
  module AuthenticatedHelper  
    protected
    # Check to see if a user is logged in
    def ensure_authenticated
      session.user = session._authentication_manager.fetch_user(session[:user])
      raise Merb::Controller::Unauthenticated unless session.user
    end 
  end
end