module Merb
  class Controller::Unauthenticated < ControllerExceptions::Unauthorized; end
  
  module AuthenticatedHelper  
    protected
    # Check to see if a user is logged in
    def ensure_authenticated(*strategies)
      session.authenticate!(self, *strategies) unless session.user
      session.user
    end 
  end
end