module MainFileUploadActions
  extend ActiveSupport::Concern

  def upload_main_file_document
    files = upload_main_file_document_params[:pdf_documents]

    description = "
#{@client_file.client} #{@client_file}
#{@client_file.accounts.order(effective_from: :desc).first}
#{@client_file.subject_matter}
"

    files.each do |file|
      file_name = file.original_filename
      contents = File.read(file.tempfile)
      name = file.original_filename
      mime_type = file.content_type
      subfolder_name = :file_main_file_folder
      AlfrescoDocumentUploadToClientFileFolder
        .upload_alfresco_document(file_name, contents, name, description, mime_type, @client_file, subfolder_name)
    end

    redirect_to @client_file, notice: 'Main File uploaded successfully.'
  end

  private

  def upload_main_file_document_params
    params.permit(pdf_documents: [])
  end
end
