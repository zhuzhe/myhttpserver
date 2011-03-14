require "exception/http_server_error"
require "server"
require "http_request"
require "http_response"

module Light

  class HttpServer < Server

    def initialize
      super
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
          req.content_type  = "text/html"
          req.body = "<html>hello</html>"
          req.send_response(sock)
          sock.close
          break
        end
      rescue HttpStatus::ServerError => e
        #      puts "#{e.class}: #{e.message}\n\t#{e.backtrace[0]}"
        req.status =  500
      rescue HttpStatus::CLIENT_ERROR => e
        req.status = 400
      ensure
        req.send_response(sock)
        sock.close
      end

    end

    def service res, req
      servlet = ""
    end

  end

end
