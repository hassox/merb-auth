if defined?(Merb::Plugins)

  require 'digest/sha1'
  require 'merb-mailer'
  require 'merb_helpers'
  
  load File.join(File.dirname(__FILE__), "merbful_authentication", "initializer.rb")
  
  Dir[File.dirname(__FILE__) / "merbful_authentication" / "controller" / "**" / "*.rb"].each do |f|
    load f
  end
  
  adapter_path = File.join( File.dirname(__FILE__), "merbful_authentication", "adapters")
  load File.join(adapter_path,  "common.rb")
  
  MA = MerbfulAuthentication
  MA.register_adapter :datamapper, "#{adapter_path}/datamapper"
  MA.register_adapter :activerecord, "#{adapter_path}/activerecord"
  
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
  Merb::Slices::config[:merbful_authentication] ||= {}
  Merb::Slices::config[:merbful_authentication][:layout] ||= :merbful_authentication
  
  # All Slice code is expected to be namespaced inside a module
  module MerbfulAuthentication


    def self.plugins
      @@plugins ||= {}
    end
    
    # Slice metadata
    self.description = "MerbfulAuthentication is a Merb slice that provides authentication"
    self.version = "0.11.0"
    self.author = "Merb Core"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally
    #
    # Loads the model class into MerbfulAuthentication[:user] for use elsewhere.
    def self.loaded
      MA.load_adapter!
      
      Merb::Controller.send(:include, MA::Controller::Helpers)
      # sends the methoods to the controllers as an include so that other mixins can
      # overwrite them
      MA::Users.send(     :include, MA::Controller::UsersBase)
      MA::Sessions.send(  :include, MA::Controller::SessionsBase)
      
      Merb::Controller.class_eval do
        alias_method :"current_#{MA[:single_user_name]}", :current_ma_user
        alias_method :"current_#{MA[:single_user_name]}=", :"current_ma_user="
      end      
      
      MA.load_plugins!
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
      plural_model_path = MA[:route_path_model] || MA[:plural_resource] 
      plural_model_path ||= "User".snake_case.singularize.pluralize
      plural_model_path = plural_model_path.to_s.match(%r{^/?(.*?)/?$})[1]
      single_model_name = plural_model_path.singularize
      
      plural_session_path = MA[:route_path_session] || "sessions"
      plural_session_path = plural_session_path.to_s.match(%r{^/?(.*?)/?$})[1]
      single_session_name = plural_session_path.singularize
      
      activation_name = (MA[:single_resource].to_s << "_activation").to_sym
      
      MA[:routes] = {:user => {}}
      MA[:routes][:user][:new]       ||= :"new_#{single_model_name}"
      MA[:routes][:user][:show]      ||= :"#{single_model_name}"
      MA[:routes][:user][:edit]      ||= :"edit_#{single_model_name}"
      MA[:routes][:user][:delete]    ||= :"delete_#{single_model_name}"
      MA[:routes][:user][:index]     ||= :"#{plural_model_path}"
      MA[:routes][:user][:activate]  ||= :"#{single_model_name}_activation"
          
      # Setup the model path
      scope.to(:controller => "Users") do |c|
        c.match("/#{plural_model_path}") do |u|
          # setup the named routes          
          u.match("/new",             :method => :get ).to( :action => "new"     ).name(MA[:routes][:user][:new])
          u.match("/:id",             :method => :get ).to( :action => "show"    ).name(MA[:routes][:user][:show])
          u.match("/:id/edit",        :method => :get ).to( :action => "edit"    ).name(MA[:routes][:user][:edit])
          u.match("/:id/delete",      :method => :get ).to( :action => "delete"  ).name(MA[:routes][:user][:delete])
          u.match("/",                :method => :get ).to( :action => "index"   ).name(MA[:routes][:user][:index])
          u.match("/activate/:activation_code", :method => :get).to( :action => "activate").name(MA[:routes][:user][:activate])
          
          # Make the anonymous routes
          u.match(%r{(/|/index)?(\.:format)?$},  :method => :get    ).to( :action => "index")
          u.match(%r{/new$},                     :method => :get    ).to( :action => "new")
          u.match(%r{/:id(\.:format)?$},         :method => :get    ).to( :action => "show")
          u.match(%r{/:id/edit$},                :method => :get    ).to( :action => "edit")
          u.match(%r{/:id/delete$},              :method => :get    ).to( :action => "delete")
          u.match(%r{/?(\.:format)?$},           :method => :post   ).to( :action => "create")      
          u.match(%r{/:id(\.:format)?$},         :method => :put    ).to( :action => "update")
          u.match(%r{/:id(\.:format)?$},         :method => :delete ).to( :action => "destroy")
        end
      end
      
      
      scope.match("/login" ).to(:controller => "sessions", :action => "create").name(:login)
      scope.match("/logout").to(:controller => "sessions", :action => "destroy").name(:logout)
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

end