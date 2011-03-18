require "http_server"
require "httpservlet/rack_handler"

require "/home/belen/server_monitor/config/environment"
require "rubygems"
require "rack"


def parse_options options
  server = Light::HttpServer.new
  server.listen("127.0.0.1", 3003)
  server.start
end

#parse_options ARGV


app = Rack::Builder.new {
  use Rails::Rack::LogTailer
#  use Rails::Rack::Debugger
#  use ActionDispatch::Static
  run ActionController::Dispatcher.new
}.to_app

Light::RackHandler.run app, :Port => 3003, :Host => "127.0.0.1"