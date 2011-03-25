
require 'rubygems'
require 'rack'

Rack::Handler::WEBrick.run lambda {|env| [200,{},
  [env.inspect]]} , :Port=>3000
