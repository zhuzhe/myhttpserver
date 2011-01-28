require "socket"
require "fcntl"

module IOUtil

  def set_non_block(io)
    flag = File::NONBLOCK
    if defined?(Fcntl::F_GETFL)
      flag |= io.fcntl(Fcntl::F_GETFL)
    end
    io.fcntl(Fcntl::F_SETFL, flag)
  end

  module_function :set_non_block

  def set_close_on_exec io
    io.fcntl(Fcntl::FD_CLOEXEC, 1)
  end

  module_function :set_close_on_exec

  def create_listeners address, port
    raise ArgumentError, "port must be provided" unless port

    res = Socket.getaddrinfo(address, port, Socket::AF_UNSPEC, Socket::SOCK_STREAM, 0, Socket::AI_PASSIVE)

    sockets = []

    res.each{|ai|
      sock = TCPServer.new(ai[3], port)
      port = sock.addr[1] if port == 0
      IOUtil::set_close_on_exec(sock)
      sockets << sock
    }
    sockets
  end

  module_function :create_listeners

end
