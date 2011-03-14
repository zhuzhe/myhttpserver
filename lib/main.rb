require "http_server"



def parse_options options
  server = Light::HttpServer.new
  server.listen("127.0.0.1", 3003)
  server.start
end

parse_options ARGV