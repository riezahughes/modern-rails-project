module AlfrescoDisclosure

  include AlfrescoDocument

  def create_disclosure_document(repository, disclosure, description, client_file, attributes = {})
    unless repository
      return nil
    end

    raise Pareclip.Exception.new('No pdf document attached') unless disclosure.pdf_document

    root_folder_id = client_file_folder_id client_file
    parent_folder = repository.object root_folder_id

    create_alfresco_document(repository,
                             disclosure.pdf_document.path,
                             disclosure.pdf_document_content_type,
                             Paperclip.io_adapters.for(disclosure.pdf_document).read,
                             disclosure.pdf_document_file_name,
                             description, parent_folder)
  end

  def client_file_folder_id(client_file)

    begin
      client_file_folder = client_file.get_alfresco_folder
    rescue ObjectNotFound
      client_file_folder = client_file.create_folder
    end

    disclosure_folder = client_file_folder.child_by_name AlfrescoConfig[:file_disclosure_folder]
    disclosure_folder.id

  end

end