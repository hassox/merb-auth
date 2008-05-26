if defined?(Merb::Plugins)

  require 'merb-slices'
  Merb::Plugins.add_rakefiles "merbful-auth-ar/merbtasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :merbful_auth_ar
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:merbful_auth_ar] = { :layout => :merbful_auth_ar }
  
  # All Slice code is expected to be namespaced inside a module
  module MerbfulAuthAr
    
    # Slice metadata
    self.description = "MerbfulAuthAr is a chunky Merb slice!"
    self.version = "0.0.1"
    self.author = "YOUR NAME"
    
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
  
  # Setup the slice layout for MerbfulAuthAr
  #
  # Use MerbfulAuthAr.push_path and MerbfulAuthAr.push_app_path
  # to set paths to merbful-auth-ar-level and app-level paths. Example:
  #
  # MerbfulAuthAr.push_path(:application, MerbfulAuthAr.root)
  # MerbfulAuthAr.push_app_path(:application, Merb.root / 'slices' / 'merbful-auth-ar')
  # ...
  #
  # Any component path that hasn't been set will default to MerbfulAuthAr.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  MerbfulAuthAr.setup_default_structure!
  
end