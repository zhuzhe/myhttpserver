require "exception/http_server_error"
require "server"
require "http_request"
require "http_response"

module Light

  class HttpServer < Server

    class HTTPServerError < ServerError; end

    def initialize options = {},  default=Config::HTTP
      super options,  default
      @mount_tab = Hash.new
    end

    def run sock
      res = HttpRequest.new @config
      req = HttpResponse.new @config
      begin
        timeout = @config[:RequestTimeout]
        while timeout > 0
          break if IO.select([sock], nil, nil, 0.5).nil?
          timeout = 0 if @status != :Running
          timeout -= 0.5

          res.parse(sock)
          req.request_method = res.request_method
          req.request_uri = res.request_uri
          req.request_http_version = res.request_http_version
          self.service(req, res)
          req.send_response(sock)
          sock.close
          break
        end

      rescue Exception => e
        puts "#{e.class}: #{e.message}\n\t#{e.backtrace[0]}"
      ensure
        req.send_response(sock)
        sock.close
      end

    end


    def mount(dir, servlet, *options)
      @logger.debug(sprintf("%s is mounted on %s.", servlet.inspect, dir))
      @mount_tab[dir] = [ servlet, options ]
    end

    def unmount(dir)
      @logger.debug(sprintf("unmount %s.", dir))
      @mount_tab.delete(dir)
    end

    def service res, req
      servlet, options = search_servlet(req.path)
      si = servlet.get_instance(self, *options)
      @logger.debug(format("%s is invoked.", si.class.name))
      si.service(req, res)
    end
    
    def search_servlet path
      if @mount_tab[path]
         @mount_tab[path]
      end
    end

  end

end
