require "util/http_util"

class HttpRequest

  include HttpUtil

  attr_reader :header

  def initialize  config
    @config = config
    @raw_header = ""
    @body = ""
    @peeraddr = nil

  end

  def parse socket
    begin
      @socket = socket
      @peeraddr = socket.respond_to?(:peeraddr) ? socket.peeraddr : []
      read_header socket
    rescue Exception => e
      puts "#{e.class}: #{e.message}\n\t#{e.backtrace[0]}"
    end
  end

  def path
    header["path_info"]
  end

  def read_header socket
    if socket
      if data = socket.read_nonblock(2048)
        @raw_header << data
        @body << data
      end
      @header = HttpUtil.parse_header(@raw_header)
      puts @raw_header
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

  def body
    @body
  end

  def read_body socket
    @body = socket.read_nonblock(2048)
  end

  def meta_vars

    meta = Hash.new

    cl = @header["content-length"]
    ct = @header["content-type"]
    meta["CONTENT_LENGTH"] = cl if cl.to_i > 0
    meta["CONTENT_TYPE"] = ct.dup if ct
    meta["GATEWAY_INTERFACE"] = "CGI/1.1"
    meta["PATH_INFO"] = @header["path_info"] ? @header["path_info"] : ""
    meta["QUERY_STRING"] = @header["query_string"] ? @header["query_string"] : ""
    meta["REMOTE_ADDR"] = @peeraddr[3]
    meta["REMOTE_HOST"] = @peeraddr[2]
    meta["REMOTE_USER"] = nil
    meta["REQUEST_METHOD"] = @header["request_method"]
    meta["REQUEST_URI"] = @header["request_uri"]
    meta["SCRIPT_NAME"] = @header["script_name"]
    meta["SERVER_NAME"] = @header['host']
    meta["SERVER_PORT"] = @header["port"]
    meta["SERVER_PROTOCOL"] = "HTTP/" + @config[:HTTPVersion].to_s
    meta["SERVER_SOFTWARE"] = @config[:ServerSoftware]

#    self.each{|key, val|
#      next if /^content-type$/i =~ key
#      next if /^content-length$/i =~ key
#      name = "HTTP_" + key
#      name.gsub!(/-/o, "_")
#      name.upcase!
#      meta[name] = val
#    }

    meta
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
