
module Light

 module HTTPServlet

    class AbstractServlet

      class HTTPServletError < StandardError; end

      def self.get_instance(server, *options)
        self.new(server, *options)
      end

       def initialize(server)
        @server = server
      end

      def service(req, res)
        method_name = "do_" + req.request_method
        if respond_to?(method_name)
          __send__(method_name, req, res)
        end
      end

      def do_GET(req, res)
        raise HttpServletError, "not found."
      end

      def do_POST(req, res)
        raise HttpServletError, "not found."
      end

      def do_HEAD(req, res)
        do_GET(req, res)
      end

    end

  end

end