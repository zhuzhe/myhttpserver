require "exception/http_server_error"
require "server"

class HttpServer < Server

  def initialize
    super
  end

  def run sock
    while true
      res = HttpRequest.new
      req = HttpResponse.new
      break if IO.select([sock], nil, nil, 0)
      res.parse(sock)
    end
  end

end
