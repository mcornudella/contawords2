class ExecutionsController < ApplicationController
    
    #load_and_authorize_resource :except => [:notify]
    protect_from_forgery prepend: true
    helper_method :current_or_guest_user
    
    def index
        @execution = Execution.new()
        @files = current_or_guest_user.uploaded_files.order("name DESC")
        @executions = current_or_guest_user.executions.order("created_at DESC").page params[:page]
    end
    
    def create
        param = {}
        if upload_file_input? && params[:upload_files].nil?
            flash[:error] = t(:error_select_input)
            elsif params[:execution][:input_parameters][:inputs][:language].empty?
            flash[:error] = t(:error_select_lang)
            else
            @execution = Execution.new(post_params)
            puts "Inspect execution"
            puts @execution.inspect
            #job = ExecuteNewPipeContawordsJob.perform_later params[:execution][:input_parameters][:inputs][:web_pages] params[:execution][:input_parameters][:inputs][:language]
            #jid = job.provider_job_id
            if @execution.save
                @execution.run!
            end
            param = {:running => true}
        end
        redirect_to executions_path(param)
    end
    
    
    #def executions_list
    #    @executions = current_or_guest_user.executions.order("created_at DESC").page params[:page]
    #    render :partial => 'list'
    #end
    
    def show
        @executions = current_or_guest_user.executions.order("created_at DESC").page params[:page]
        render :partial => 'list'
    end
    
    private
    
    def upload_file_input?
        params[:execution][:type] == "upload_files"
    end
    
    def join_file_urls
        #params.require(:execution).permit(:type, :input_parameters)
        params.permit(:upload_files)
        files = params[:upload_files]
        #puts "files join_file_urls"
        #puts files
        file_urls = UploadedFile.find(files).map { |file| URI.join("http://#{UPLOADED_FILES_BASE_URL}", file.file.url).to_s }.join("\n")
        #file_urls = UploadedFile.find(files).map { |file| file.file.url }.join("\n")
        #puts "Params"
        #puts params.inspect
        #puts "file_urls"
        #puts file_urls
        
        params[:execution][:input_parameters][:inputs][:web_pages] = file_urls
    end
    
    def download_file_urls
       params.permit!
       puts "Params inside download_file_urls"
       puts params.inspect
    end
    
    def post_params
        #params.require(:execution).permit!
        #params.require(:execution).permit(:type, :input_parameters)
        params.permit!
        if upload_file_input?
            join_file_urls
        end
        #join_file_urls if upload_file_input?
        #puts "params[:execution].inspect"
        #puts params[:execution].inspect
        
        attributes = params.require(:execution).permit(:type, input_parameters: {})
        attributes = params[:execution].slice(:input_parameters)
        #puts "params[:execution][:input_parameters][:inputs]"
        #puts params[:execution][:input_parameters][:inputs]
        
        attributes[:user_id] = current_or_guest_user.id
        #puts "attributes ending"
        #puts attributes
        attributes
    end
    
    def session_id
        request.session_options[:id]
    end
    
end
