module Authentication
  class Manager
    include Extlib::Hook
    attr_accessor :session
    
    def initialize(session)
      @session = session
    end
    
    ##
    # @return [TrueClass, FalseClass]
    # 
    def authenticated?
      !!user
    end
    
    ##
    # returns the active user for this session, or nil if there's no user claiming this session
    # @returns [User, NilClass]
    def user
      return nil if !session[:user]
      @user ||= fetch_user(session[:user])
    end
    
    ## 
    # allows for manually setting the user
    # @returns [User, NilClass]
    def user=(user)
      session[:user] = nil && return if user.nil?
      session[:user] = store_user(user)
      @user = session[:user] ? user : session[:user]  
    end
    
    ##
    # retrieve the claimed identity and verify the claim
    # 
    # Uses the strategies setup on Authentication executed in the context of the controller to see if it can find
    # a user object
    # @return [User, NilClass] the verified user, or nil if verification failed
    # @see User::encrypt
    # 
    def authenticate(controller, opts = {})
      msg = opts.delete(:message) || "Could Not Log In"
      user = nil    
      # This one should find the first one that matches.  It should not run antother
      Authentication.login_strategies.detect do |s|
        user = controller.instance_eval(&s)
      end
      raise Merb::Controller::Unauthenticated, msg unless user
      self.user = user
    end
    
    ##
    # abandon the session, log out the user, and empty everything out
    # 
    def abandon!
      @user = nil
      session.delete
    end
    
    # Overwrite this method to store your user object in the session.  The return value of the method will be stored
    def store_user(user)
      raise NotImplemented
    end
    
    # Overwrite this method to fetch your user from the session.  The return value of this will be stored as the user object
    # return nil to stop login
    def fetch_user(session_contents = session[:user])
      raise NotImplemented
    end
    
  end # Manager
end # Authentication