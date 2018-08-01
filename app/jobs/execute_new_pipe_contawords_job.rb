class ExecuteNewPipeContawordsJob #< ApplicationJob
    
    #queue_as :high #:default
    include SuckerPunch::Job
    workers 5
    
  
  
  #after_perform do |job|
  #  puts "#{Time.current}: finished execution of the job: #{job.inspect}"
  #  end

  def perform(input_parameters, object)
      #puts "Input input_parameters inside job:"
      #puts input_parameters
      #puts "Input input_parameters[:inputs] inside job:"
      #puts input_parameters[:inputs]
      #puts "Input input_parameters[:inputs][:web_pages].squish inside job:"
      #puts input_parameters[:inputs][:web_pages].squish
      #puts "Input input_parameters[:inputs][:language] inside job:"
      #puts input_parameters[:inputs][:language]
      ActiveRecord::Base.connection_pool.with_connection do
          executeContawordsScript(input_parameters, object)
      end
      #web_pages=input_parameters[:inputs][:web_pages].squish
      #language=input_parameters[:inputs][:language]
      #puts `/Users/miquelcornudella/Documents/IULA/tasques/contawords/scripts/pipa_contawords_URL_list.sh "#{web_pages}" #{language}`
  end

    private

        def executeContawordsScript(input_parameters,object)
            #object[:status] = "initialized"
            web_pages=input_parameters[:inputs][:web_pages].squish
            language=input_parameters[:inputs][:language]
            #puts "Input object"
            #puts object.inspect
            job_output = `/Users/miquelcornudella/Documents/IULA/tasques/contawords/scripts/pipa_contawords_URL_list.sh "#{web_pages}" #{language}`
            #puts "job_output:"
            #puts job_output
            object[:status] = "finished"
            object[:updated_at] = Time.new.inspect
            object[:results] = job_output.squish
            #puts "Output object"
            #puts object.inspect
            object.save
        end

end
