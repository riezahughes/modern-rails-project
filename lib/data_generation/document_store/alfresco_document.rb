module AlfrescoDocument

  def create_alfresco_document(repository, file_name, mime_type, contents, name, description, parent_folder)
    begin

      Rails.logger.info "Creating document #{name} in #{parent_folder.name} (#{parent_folder.cmis_object_id})"

      document = repository.new_document
      document.name = name
      document.description = description
      document.object_type_id = 'cmis:document'
      document.content = {
          stream: contents,
          mime_type: mime_type,
          filename: file_name
      }
      document.create_in_folder(parent_folder)

    rescue CMIS::Exceptions::ContentAlreadyExists => e
      Rails.logger.warn "#{name} already exists"
      raise DocumentExists.new "#{name} already exists"
    end
  end

  def delete_alfresco_document(alfresco_document)
    alfresco_document.delete
  end

end
