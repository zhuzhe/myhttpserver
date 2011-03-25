require "httpservlet/abstract_servlet"

module Light

  class RackHandler < ::Light::HTTPServlet::AbstractServlet

    def initialize server, app
      super server
      @app = app
    end

    def self.run app, options = {}
      @server = ::Light::HttpServer.new(options)
      @server.listen(@server.config[:Host],  @server.config[:Port])
      @server.mount "/", RackHandler, app
      yield @server if block_given?
      @server.start
    end

    def self.shutdown
      @server.shutdown
      @server = nil
    end

    def service(req, res)
      env = req.meta_vars
      env.delete_if { |k, v| v.nil? }

      rack_input = StringIO.new(req.body.to_s)
      rack_input.set_encoding(Encoding::BINARY) if rack_input.respond_to?(:set_encoding)
      
      env.update({"rack.version" => [1,1],
          "rack.input" => rack_input,
          "rack.errors" => $stderr,

          "rack.multithread" => true,
          "rack.multiprocess" => false,
          "rack.run_once" => false,

          "rack.url_scheme" => "http"
        })
      env["HTTP_VERSION"] ||= env["SERVER_PROTOCOL"]
      env["QUERY_STRING"] ||= ""
      env["REQUEST_PATH"] ||= "/"

      status, headers, body = @app.call(env)
      begin
        res.status = status.to_i
        headers.each { |k, vs|
          if k.downcase == "set-cookie"
            res.cookies.concat vs.split("\n")
          else
            vs.split("\n").each { |v|
              res[k] = v
            }
          end
        }
        body.each { |part|
          res.body << part
        }
      ensure
        body.close if body.respond_to? :close
      end
    end

   
  end

end
