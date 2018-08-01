class FilesController < ApplicationController
  helper_method :current_or_guest_user
  
  def index
    @files = current_or_guest_user.uploaded_files.order("name DESC").page params[:page]
  end

  def new
    @file = UploadedFile.new(name: "New file")
    render :show
  end

  def show
    @file = UploadedFile.find(params[:id])
    authorize! :show, @file
  end

  def create
    if params[:uploaded_file].nil?
        flash[:error] = t(:error_no_file)
    elsif invalid_params?
        flash[:error] = t(:error_wrong_file_format)
    else
        @file = UploadedFile.new(post_params)
        authorize! :create, @file

        @file.user = current_or_guest_user

        if @file.save
            redirect_to executions_path
        else
            render :action => :new
        end
    end
  end

  def update
    @file = UploadedFile.find(params[:id])
    authorize! :update, @file

    @file.update_attributes(put_params)
    render :show
  end

  def destroy
    @file = UploadedFile.find(params[:id])
    authorize! :destroy, @file

    @file.destroy
    redirect_to :action => :index
  end


  private

  def put_params
      params.permit!
      params[:uploaded_file].slice(:name, :description)
  end

  def invalid_params?
     params.permit!
     ["text/plain","application/pdf"].exclude?(params[:uploaded_file][:file].content_type)
 end

  def post_params
      params.permit!
      params[:uploaded_file].slice(:name, :description, :file)
  end
end
