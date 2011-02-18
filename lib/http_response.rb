# To change this template, choose Tools | Templates
# and open the template in the editor.

class HttpResponse

  attr_accessor :request_uri, :request_method, :request_http_version
  attr_accessor :header, :body

   def send_response(socket)
      begin
        setup_header()
        send_header(socket)
        send_body(socket)
      end
    end

    def setup_header()

    end

    def send_header(socket)
      socket << @header
    end

    def send_body(socket)
      socket << @body
    end

end
