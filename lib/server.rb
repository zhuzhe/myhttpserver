require "exception/server_error"
require "util/io_util"

class Server
  
  attr_reader :status, :logger, :config, :listeners

  def initialize
    @config = []
    @listeners = []
    @status = :Stop
  end
  
  def start &block
    raise ServerError, "server has already run" if @status == :Running

    puts "#{self.class}#start: pid=#{$$}"

    thread_group = ThreadGroup.new

    @status = :Running

    while @status == :Running
      begin
        if sockets_array = IO.select(@listeners, nil, nil, 2.0)
          sockets_array[0].each do |sock|
            if socket = accept_client(sock)
              thread = start_thread(socket, &block)
              thread[:SocketThread] = true
              thread_group.add thread
            end
          end
        end
      end
    end
    thread_group.list.each { |th| th.join if th[:SocketThread] }
    @status = :Stop
  end

  def listen address, port
    @listeners += IOUtil::create_listeners(address, port)
  end

  def stop
    if @status == :Running
      @status = :Stop
    end
  end

  def shutdown
    stop
    @listeners.each{|sock|
      sock.close
    }
    @listeners.clear
  end
  
  def accept_client socket
    sock = nil
    begin
      sock = socket.accept
    end
    sock
  end

  def start_thread sock, &block
    Thread.start do
      Thread.current[:Socket] = sock
     
      block ? block.call(sock) : run(sock)
    end
  end

  def run sock
    puts "run must be provide by yourself"
  end

  def do_get

  end

  def do_post

  end

  def do_option

  end

end
