if defined?(Merb::Plugins)

  require 'merb-slices'
  require File.join(File.dirname(__FILE__), "merbful_authentication", "initializer")
  
  Merb::Plugins.add_rakefiles "merbful_authentication/merbtasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :merbful_authentication
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:merbful_authentication] = { :layout => :merbful_authentication }
  
  # All Slice code is expected to be namespaced inside a module
  module MerbfulAuthentication
    
    # Slice metadata
    self.description = "MerbfulAuthentication is a Merb slice that provides authentication"
    self.version = "0.11.0"
    self.author = "Merb Core"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
      class_name = self.config[:user_class_name] || "User"
      MA.load_adapter!
      Object.full_const_set(class_name, MA::Model.clone)
      MA[:user] = Object.full_const_get(class_name)
      MA.remove_default_model_klass! 
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end
    
    # Deactivation hook - triggered by Merb::Slices#deactivate
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    def self.setup_router(scope)
    end
    
  end
  
  # Setup the slice layout for MerbfulAuthentication
  #
  # Use MerbfulAuthentication.push_path and MerbfulAuthentication.push_app_path
  # to set paths to merbful_authentication-level and app-level paths. Example:
  #
  # MerbfulAuthentication.push_path(:application, MerbfulAuthentication.root)
  # MerbfulAuthentication.push_app_path(:application, Merb.root / 'slices' / 'merbful_authentication')
  # ...
  #
  # Any component path that hasn't been set will default to MerbfulAuthentication.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  MerbfulAuthentication.setup_default_structure!
  MA = MerbfulAuthentication
end