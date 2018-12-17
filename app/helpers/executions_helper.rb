module ExecutionsHelper
    
    def execution_status_class(execution)
        
        case execution.status
            when "initialized"  then "label-warning"
            when "running"  then "label-warning"
            when "finished"  then "label-success"
            when "error" then "label-danger"
            else "label-danger"
        end
    end
    
    def execution_status_name(execution)
        return t(:finished) if execution.finished?
        return t(:error) if execution.error?
        t(:counting)
    end
end
