require "http_server"
require "httpservlet/rack_handler"



def parse_options options
  server = Light::HttpServer.new
  server.listen("127.0.0.1", 3003)
  server.start
end

#parse_options ARGV

Light::RackHandler.run lambda {|env| [200,{},
      ["your request:
  http_method => #{env['REQUEST_METHOD']}
  path => #{env['PATH_INFO']}
  params=>#{env['QUERY_STRING']}"]]}, :Port => 3003, :Host => "127.0.0.1"