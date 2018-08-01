class UploadedFile < ApplicationRecord
    has_attached_file :file
    
    #validates_attachment_presence :file, :content_type => ["text/plain", "application/pdf"],
    #                                     :message => ', Only PDF or TEXT files are allowed. '
    #validates_attachment_presence :file
    
    validates_attachment :file, content_type: { content_type: ["text/plain", "application/pdf"] }

    
    belongs_to :user
end
