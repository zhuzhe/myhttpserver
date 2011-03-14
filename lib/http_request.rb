require "util/http_util"

class HttpRequest

  include HttpUtil

  attr_reader :header

  def initialize
    @raw_header = ""
  end

  def parse socket
    begin
      read_header socket
    rescue Exception => e
      puts "#{e.class}: #{e.message}\n\t#{e.backtrace[0]}"
    end
  end

  def read_header socket
    if socket
      if data = socket.read_nonblock(2048)
        @raw_header << data
      end
      @header = HttpUtil.parse_header(@raw_header)
      puts @header.inspect
    end
  end

  def request_method
    @header["request_method"]
  end

  def request_uri
    @header["request_uri"]
  end

  def request_http_version
    @header["http_version"]
  end

  def keep_alive?
    if @header["connection"] == "keep-alive"
      true
    else
      false
    end
  end



  def _read_data(io, method, *arg)
    io.__send__(method, *arg)
  end

  def read_line(io)
    _read_data(io, :gets, LF)
  end

  def read_data(io, size)
    _read_data(io, :read, size)
  end



end
