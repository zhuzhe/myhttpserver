
require "util/io_util"
require "log"
require "config"

module Light

  

  class Server

    class ServerError < StandardError; end
  
    attr_reader :status, :logger, :config, :listeners

    def initialize config = {}, default = Config::General
      @config = default.dup.update(config)
      @config[:Log] ||= Log.new
      @logger = @config[:Log]
      @logger.info("Light HTTP Web Server")
      @listeners = []
      @status = :Stop
      @workers = []
    end
  
    def start &block
      raise ServerError, "server has already run" if @status == :Running

      @logger.info "#{self.class}#start: pid=#{$$}   #{@config[:Host]}:#{@config[:Port]}"

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
        rescue Errno::EBADF, IOError => ex
          msg = "#{ex.class}: #{ex.message}\n\t#{ex.backtrace[0]}"
          @logger.error msg
        end
      end

      @logger.info "going to shutdown ..."
      thread_group.list.each { |th| th.join if th[:SocketThread] }
      @logger.info "#{self.class}#has already shutdown"
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

  end

end
