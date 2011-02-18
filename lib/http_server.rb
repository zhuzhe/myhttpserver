require "exception/http_server_error"
require "server"
require "http_request"
require "http_response"

class HttpServer < Server

  def initialize
    super
    HttpRequest
  end

  def run sock
    res = HttpRequest.new
    req = HttpResponse.new
    begin
      while true
        break unless IO.select([sock], nil, nil, 0.5)
        res.parse(sock)
        #        p sock.read_nonblock(1024)
        req.request_method = res.request_method
        req.request_uri = res.request_uri
        req.request_http_version = res.request_http_version
        
        sock << "hello"
        sock.close
        break
      end
    rescue Exception => e
      puts "#{e.class}: #{e.message}\n\t#{e.backtrace[0]}"
    end

  end

  def service res, req
    servlet = ""
  end

end
