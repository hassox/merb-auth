if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  load_dependency 'merb-slices'
  require 'mauth-core'
  Merb::Plugins.add_rakefiles "mauth_password_slice/merbtasks", "mauth_password_slice/slicetasks", "mauth_password_slice/spectasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :mauth_password_slice
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:mauth_password_slice][:layout] ||= :application
  
  # All Slice code is expected to be namespaced inside a module
  module MauthPasswordSlice
    
    # Slice metadata
    self.description = "MauthPasswordSlice is a merb slice that provides basic password based logins"
    self.version = "0.0.1"
    self.author = "Daniel Neighman"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
      raise "Please set the :user_class option for MauthPasswordSlice" unless MPS[:user_class]
      MPS[:login_field]                 ||= {:label => "Login",     :method => :login}
      MPS[:password_field]              ||= {:label => "Password",  :method => :password}
      
      # This is where the work happens when users login
      Authentication.login_strategies.add(:password_login_from_form) do
        MPS[:user_class].authenticate(params[:login], params[:password])
      end

      Authentication.login_strategies.add(:password_login_basic_auth) do
        basic_authentication.authenticate do |login, password|
          MPS[:user_class].authenticate(login, password)
        end
      end
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(MauthPasswordSlice)
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :mauth_password_slice_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      # example of a named route
      # scope.match('/index.:format').to(:controller => 'main', :action => 'index').name(:mauth_password_slice_index)
      scope.match("/login", :method => :put).to(:controller => "sessions", :action => "update").name(:mauth_perform_login)
    end
    
  end
  
  # Setup the slice layout for MauthPasswordSlice
  #
  # Use MauthPasswordSlice.push_path and MauthPasswordSlice.push_app_path
  # to set paths to mauth_password_slice-level and app-level paths. Example:
  #
  # MauthPasswordSlice.push_path(:application, MauthPasswordSlice.root)
  # MauthPasswordSlice.push_app_path(:application, Merb.root / 'slices' / 'mauth_password_slice')
  # ...
  #
  # Any component path that hasn't been set will default to MauthPasswordSlice.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  MauthPasswordSlice.setup_default_structure!
  
  MPS = MauthPasswordSlice
  # Add dependencies for other MauthPasswordSlice classes below. Example:
  # dependency "mauth_password_slice/other"
  
end