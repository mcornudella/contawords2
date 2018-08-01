class Execution < ApplicationRecord

    serialize :results
    serialize :input_parameters
    
    belongs_to :user

    
    def run!
        self.status = "initialized"
        ExecuteNewPipeContawordsJob.perform_async(input_parameters, self)
        #self.pipe_id = ExecuteNewPipeContawordsJob.perform_now(input_parameters)
        #self.status = :initialized
        save
    end
    
    #def update_status
    #   return if pipe_id.nil?
    #
    #   self.status = pipe_id.status
    #end
    
    def finished?
        #all_stats = SuckerPunch::Queue.stats
        #stats =  all_stats[self.pipe_id.to_s]
        #puts "State self.pipe_id:"
        #puts all_stats
        #puts all_stats[ExecuteNewPipeContawordsJob.to_s]
        #puts "end stats"
        self.status == "finished"
    end
    
    def running?
        self.status == "running"
    end
    
    def initialized?
        self.status == "initialized"
    end
    
    def error?
        self.status == "error"
    end
  
end
