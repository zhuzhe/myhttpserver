require "util/http_util"

class HttpRequest

  def initialize
    @raw_header = []
  end

  def read_header socket
    if socket
      while line = read_line(socket)
        @raw_header << line
      end
      @header = HttpUtil.parse_header(@raw_header)
      puts @header
    end
  end


  private

  def _read_data io, method, *args
    io._send_(method, *args)
  end

  def read_line io, size = 4096
    _read_data io, :gets, "\n", size
  end

  def read_data io, size
    _read_data io, :read,size
  end

end
