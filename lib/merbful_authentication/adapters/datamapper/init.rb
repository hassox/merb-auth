require 'dm-validations'
require 'dm-timestamps'

path = File.dirname(__FILE__)

Object.class_eval("class #{MA[:user_class_name].to_const_string};end")

MA[:user] = Object.full_const_get(MA[:user_class_name])

load path / "map.rb"
load path / "model.rb"
