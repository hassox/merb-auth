require 'rubygems'
require 'merb-core'
require 'spec'

# Add the dependency in a before_app_loads hook
Merb::BootLoader.before_app_loads { require(File.join(File.dirname(__FILE__), '..', 'lib', 'merbful_authentication')) }

# Using Merb.root below makes sure that the correct root is set for
# - testing standalone, without being installed as a gem and no host application
# - testing from within the host application; its root will be used
Merb.start_environment(
  :testing => true, 
  :adapter => 'runner', 
  :environment => ENV['MERB_ENV'] || 'test',
  :merb_root => Merb.root
)

Merb::Config.use do |c|
  c[:session_store] = "memory"
end

class Merb::Mailer
  self.delivery_method = :test_send
end

path = File.dirname(__FILE__)
# Load up all the shared specs
Dir[path / "shared_specs" / "**" / "*_spec.rb"].each do |f|
  require f
end

# Load up all the spec helpers
Dir[path / "spec_helpers" / "**" / "*.rb"].each do |f|
  require f
end

module Merb
  module Test
    module SliceHelper
      
      # The absolute path to the current slice
      def current_slice_root
        @current_slice_root ||= File.expand_path(File.join(File.dirname(__FILE__), '..'))
      end
      
      # Whether the specs are being run from a host application or standalone
      def standalone?
        not $SLICED_APP
      end
      
    end
  end
end

Spec::Runner.configure do |config|
  config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::ControllerHelper)
  config.include(Merb::Test::SliceHelper)
  config.include(ValidModelHashes)
end



