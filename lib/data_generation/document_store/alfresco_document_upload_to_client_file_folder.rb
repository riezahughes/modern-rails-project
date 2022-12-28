class AlfrescoDocumentUploadToClientFileFolder

  extend AlfrescoConnection
  extend AlfrescoDocument
  extend AlfrescoFolder

  def self.upload_alfresco_document(file_name, contents, name, description, mime_type, client_file, subfolder_name)
    repository = get_repository repository
    check_repository! repository

    root_folder_id = document_folder_id client_file, subfolder_name, repository
    parent_folder = get_object_by_id root_folder_id

    create_alfresco_document(repository,
       name,
       mime_type,
       contents,
       name,
       description, parent_folder)
  end

  private
  def self.document_folder_id(client_file, subfolder_name, repository)

    begin
      client_file_folder = client_file.get_alfresco_folder
    rescue ObjectNotFound
      client_file_folder = client_file.create_folder
    end

    templated_document_folder = client_file_folder.child_by_name AlfrescoConfig[subfolder_name]
    if templated_document_folder.nil?
      create_subfolder(repository, AlfrescoConfig[subfolder_name], '', client_file_folder.object)
      templated_document_folder = client_file_folder.child_by_name AlfrescoConfig[subfolder_name]
    end
    templated_document_folder.id

  end

  def self.create_subfolder(repository, name, description, parent_folder)
    create_alfresco_folder(repository, name, description, parent_folder, subfolder_names = nil)
  end

  def self.get_repository(repository)
    @repository = repository if repository
    repository = @repository

    if !repository
      repository = connect_to_alfresco
    end
    repository
  end

  def self.check_repository!(repository)
    unless repository
      Rails.logger.error 'Unable to connect to document store repository'
      raise DocumentTemplatingError.new 'Unable to connect to document store repository'
    end
  end
end
