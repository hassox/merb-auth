# make sure we're running inside Merb
if defined?(Merb::Plugins)
  require 'extlib'
  
  Merb::BootLoader.before_app_loads do
    # require code that must be loaded before the application
    require 'mauth-core/strategy_container'
    require 'mauth-core/authenticated_manager'
    require 'mauth-core/authenticated_session'
    require 'mauth-core/authenticated_helper'
    Merb::Controller.send(:include, Merb::AuthenticatedHelper)
    Merb::Controller.before :ensure_authenticated
  end
  
  Merb::BootLoader.after_app_loads do
    # code that can be required after the application loads
  end
  
  Merb::Plugins.add_rakefiles "mauth-core/merbtasks"
  
  # injecting Merb::DataMapperSession with authentication extensions
  class Merb::BootLoader::AuthenticatedSessions < Merb::BootLoader
    after MixinSessionContainer

    def self.run
      # Very kludgy way to get at the sessions object in include the new stuff
      Merb.logger.info "Mixing in Authentication Session into the session object"
      controller = Application.new(Merb::Request.new({}))
      controller.setup_session
      controller.session.class.send(:include,  Authentication::Session)    
    end

  end
end