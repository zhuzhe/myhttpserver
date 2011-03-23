require "util/http_util"

class HttpRequest

  include HttpUtil

  attr_reader :status_line, :header, :body, :port, :server_name

  def initialize  config
    @config = config
    @logger = @config[:Log]
    @raw = ""
    @body = ""
    @peeraddr = nil

  end

  def parse socket
    begin
      @socket = socket
      @peeraddr = socket.respond_to?(:peeraddr) ? socket.peeraddr : []
      if data = socket.read_nonblock(2048)
        @raw << data
      end
      @status_line, @header, @body = HttpUtil.parse_request(@raw)
      @server_name, @port = @header["host"].split(":")
    rescue Exception => e
      puts "#{e.class}: #{e.message}\n\t#{e.backtrace[0]}"
    end
  end

  def path
    @status_line["path_info"]
  end

  def request_method
    @status_line["request_method"]
  end

  def request_uri
    @status_line["request_uri"]
  end

  def request_http_version
    @status_line["http_version"]
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

  def meta_vars

    meta = Hash.new

    cl = @header["content-length"]
    ct = @header["content-type"]
    meta["CONTENT_LENGTH"] = cl if cl.to_i > 0
    meta["CONTENT_TYPE"] = ct.dup if ct
    meta["GATEWAY_INTERFACE"] = "CGI/1.1"
    meta["PATH_INFO"] = @status_line["path_info"] ? @status_line["path_info"] : ""
    meta["QUERY_STRING"] = @status_line["query_string"] ? @status_line["query_string"] : ""
    meta["REMOTE_ADDR"] = @peeraddr[3]
    meta["REMOTE_HOST"] = @peeraddr[2]
    meta["REMOTE_USER"] = nil
    meta["REQUEST_METHOD"] = @status_line["request_method"]
    meta["REQUEST_URI"] = @status_line["request_uri"]
    meta["SCRIPT_NAME"] = @status_line["script_name"]
    p meta["SERVER_NAME"] = @server_name
    p meta["SERVER_PORT"] = @port
    meta["SERVER_PROTOCOL"] = "HTTP/" + @config[:HTTPVersion].to_s
    meta["SERVER_SOFTWARE"] = @config[:ServerSoftware]

    self.each{|key, val|
      next if /^content-type$/i =~ key
      next if /^content-length$/i =~ key
      name = "HTTP_" + key
      name.gsub!(/-/o, "_")
      name.upcase!
      meta[name] = val
    }

    meta
  end

  def each
    @header.each{|k, v|
      yield(k, v)
    }
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
