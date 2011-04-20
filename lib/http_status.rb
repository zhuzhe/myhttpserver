
module Light

  module HttpStatus


    class Status < StandardError; end
    class Info < Status; end
    class Success < Status; end
    class Redirect < Status; end
    class Error < Status; end
    class ClientError < Error; end
    class ServerError < Error; end


    INFO = "INFO"
    SUCCESS = "SUCCESS"
    REDIRECT = "REDIRECT"
    CLIENT_ERROR =  "CLIENT ERROR"
    SERVER_ERROR = "SERVER ERROR"


    StatusMessage = {
      100 => 'Continue',
      101 => 'Switching Protocols',
      200 => 'OK',
      201 => 'Created',
      202 => 'Accepted',
      203 => 'Non-Authoritative Information',
      204 => 'No Content',
      205 => 'Reset Content',
      206 => 'Partial Content',
      300 => 'Multiple Choices',
      301 => 'Moved Permanently',
      302 => 'Found',
      303 => 'See Other',
      304 => 'Not Modified',
      305 => 'Use Proxy',
      307 => 'Temporary Redirect',
      400 => 'Bad Request',
      401 => 'Unauthorized',
      402 => 'Payment Required',
      403 => 'Forbidden',
      404 => 'Not Found',
      405 => 'Method Not Allowed',
      406 => 'Not Acceptable',
      407 => 'Proxy Authentication Required',
      408 => 'Request Timeout',
      409 => 'Conflict',
      410 => 'Gone',
      411 => 'Length Required',
      412 => 'Precondition Failed',
      413 => 'Request Entity Too Large',
      414 => 'Request-URI Too Large',
      415 => 'Unsupported Media Type',
      416 => 'Request Range Not Satisfiable',
      417 => 'Expectation Failed',
      500 => 'Internal Server Error',
      501 => 'Not Implemented',
      502 => 'Bad Gateway',
      503 => 'Service Unavailable',
      504 => 'Gateway Timeout',
      505 => 'HTTP Version Not Supported'
    }

    def type(code)
      case code
      when 100...200
        HttpStatus::INFO
      when 200...300
        HttpStatus::REDIRECT
      when 300...400
        HttpStatus::CLIENT_ERROR
      when 400...500
        HttpStatus::SERVER_ERROR
      end
    end


    def reason_phrase(code)
      status_message = StatusMessage[code.to_i]
      status_message ? status_message : 'UNKNOWN'
    end

    def info?(code)
      code.to_i >= 100 and code.to_i < 200
    end

    def success?(code)
      code.to_i >= 200 and code.to_i < 300
    end

    def redirect?(code)
      code.to_i >= 300 and code.to_i < 400
    end

    def error?(code)
      code.to_i >= 400 and code.to_i < 600
    end

    def client_error?(code)
      code.to_i >= 400 and code.to_i < 500
    end

    def server_error?(code)
      code.to_i >= 500 and code.to_i < 600
    end

    module_function :reason_phrase, :info?, :success?, :redirect?, :error?, :client_error?, :server_error?




  end

end
