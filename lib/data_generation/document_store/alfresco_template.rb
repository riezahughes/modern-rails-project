module AlfrescoTemplate

  include AlfrescoDocument
  include AlfrescoFolder

  def create_template_document(repository, template, description)
    unless repository
      Rails.logger.error 'Unable to connect to document store repository'
      return nil
    end

    unless !template.template_file.present?
      Rails.logger.error "Template file has not been saved on the application server for template #{template}"
      return nil
    end

    root_folder_id = template_folder_id repository
    parent_folder = get_object_by_id root_folder_id

    create_alfresco_document(repository,
                             template.template_file.path,
                             template.template_file_content_type,
                             Paperclip.io_adapters.for(template.template_file).read,
                             template.template_file_file_name,
                             description, parent_folder)
  end

  def template_folder_id(repository)
    tempalte_folder_id = get_id_for_name AlfrescoConfig[:template_folder]

    unless tempalte_folder_id
      template_folder = create_alfresco_folder(repository, AlfrescoConfig[:template_folder], 'Document templates', get_object_by_id(AlfrescoConfig[:app_root_folder_id]))

      raise ObjectNotFound.new("Cannot create template folder #{AlfrescoConfig[:template_folder]}") unless template_folder
      tempalte_folder_id = template_folder.cmis_object_id
    end

    tempalte_folder_id

  end

end
