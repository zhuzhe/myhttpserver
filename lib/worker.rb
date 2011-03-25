
module Light

  class Worker
    
    MAX_SIZE = 20
    MAX_SIZE_PER_PROCESS = 500
    
    atrr_reader :max_size, :max_size_per_process
    attr_accessor :all

    def initialize config
      @max_size =  config[:Max_Size] || MAX_SIZE
      @max_size_per_process = config[:Max_Size_Per_Process] || MAX_SIZE_PER_PROCESS
      @all = []
    end
    
    def find worker_pid
      
    end




  end

end
