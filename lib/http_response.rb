require "util/http_util"
require "http_status"

module Light

  class HttpResponse

    include HttpUtil
    include HttpStatus

    attr_accessor :request_uri, :request_method, :request_http_version
    attr_accessor :header, :body


    def initialize config
      @header = Hash.new
      @body = ""
      @status = 200
      @reason_phrase = nil
    end

    def [](field)
      @header[field.downcase]
    end

    def []=(field, value)
      @header[field.downcase] = value.to_s
    end

    def content_type
      self['content-type']
    end

    def content_type=(type)
      self['content-type']  = type.to_s
    end

    def content_length
      self['content-length']
    end

    def content_length=(length)
      self['content-length'] = length
    end

    def each
      @header.each{|key,  value| yield( key, value)}
    end

    def send_response(socket)
      begin
        setup_header()
        send_header(socket)
        send_body(socket)
      rescue Errno::EPIPE, Errno::ECONNRESET, Errno::ENOTCONN => ex
      rescue Exception => ex
      end
    end

    def status_line
      "HTTP/#{@http_version} #{@status} #{@reason_phrase} #{CRLF}"
    end

    def status=(status)
      @status = status
      @reason_phrase = HttpStatus::reason_phrase(status)
    end

    def setup_header()
      @header['date']  = Time.now.strftime("%a, %d %b %Y %X GMT")
      if @status == 304 || @status == 204 || @status == HttpStatus::info?(@status)
        @header.delete('content-length')
        @body = ""
      elsif @header['content-length'].nil?
        if @body.nil?
          @header['content-length'] = 0
        else
          @header['content-length'] = @body.bytesize
        end
      end
      @header['connection'] = 'close'
    end

    def send_header(socket)
      data = status_line
      @header.each do |key, value|
        temp = key.gsub(/\b\w\b|\-\w/){$&.upcase}
        data << "#{temp}: #{value}" << CRLF
      end
      data << CRLF

      _write_data(socket, data)
    end

    def send_body(socket)
      _write_data(socket, @body)
    end

    def _write_data socket, data
      socket << data
    end

  end

end
