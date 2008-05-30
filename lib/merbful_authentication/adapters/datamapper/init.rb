require 'dm-validations'
require 'dm-timestamps'

path = File.dirname(__FILE__)

if Merb.env?(:test)
  load path / ".." / "common.rb"
  load path / "map.rb"
  load path / "model.rb"

else
  require path / ".." / "common"
  require path / "map"
  require path / "model"
end
