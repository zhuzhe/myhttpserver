# To change this template, choose Tools | Templates
# and open the template in the editor.

module Light

  class Log

    FATAL, ERROR, WARN, INFO, DEBUG = 1, 2, 3, 4, 5

    TIME_FORMAT = "[%Y-%m-%d %H:%M:%S]"

    attr_accessor :level, :time_format

    def initialize  log_file = nil, level = nil
      @level = level || INFO
      case log_file
      when String
        @log = open(log_file, "a+")
        @log.sync = true
        @opened = true
      when NilClass
        @log = $stderr
      else
        @log = log_file
      end

    end
  
    def close
      @log.close if @opened
      @log.nil
    end
  
    def log level, data
      tmp = Time.now.strftime(TIME_FORMAT)
      tmp << " " << data
      if @log && level <= @level
        tmp += "\n" if /\n$/ !~ data
        @log << tmp
      end
    end
  
    def << data
      log(INFO, data)
    end

    def fatal(msg) log(FATAL, "FATAL " << format(msg)); end
    def error(msg) log(ERROR, "ERROR " << format(msg)); end
    def warn(msg) log(WARN, "WARN " << format(msg)); end
    def info(msg) log(INFO, "INFO " << format(msg)); end
    def debug(msg) log(DEBUG, "DEBUG " << format(msg)); end

    def fatal?; @level >= FATAL; end
    def error?; @level >= ERROR; end
    def warn?; @level >= WARN; end
    def info?; @level >= INFO; end
    def debug?; @level >= DEBUG; end

    private

    def format(arg)
      if arg.is_a?(Exception)
        "#{arg.class}: #{arg.message}\n\t" <<
          arg.backtrace.join("\n\t") << "\n"
      elsif arg.respond_to?(:to_s)
        arg.to_s
      else
        arg.inspect
      end
    end


  end

end
