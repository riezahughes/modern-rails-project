class AlfrescoTemplatedDocument

  extend AlfrescoDocument
  extend AlfrescoFolder
  extend AlfrescoConnection

  def self.create_templated_document(client_file, document_template, current_user, document_templateable = nil, repository = nil)
    repository = get_repository repository
    check_repository! repository
    check_document_template! document_template

    templated_document_contents = render_contents_from_template(document_template, client_file, document_templateable, current_user)

    templated_document_name = document_name document_template
    root_folder_id = templated_document_folder_id client_file, document_template.template_type
    parent_folder = get_object_by_id root_folder_id

    create_alfresco_document(repository,
                             templated_document_name,
                             "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                             templated_document_contents,
                             templated_document_name,
                             "Temporary description", parent_folder)
  end

  def self.import_existing_document(client_file, contents, file_name, templateable_type, repository = nil)
    repository = get_repository repository
    check_repository! repository

    root_folder_id = templated_document_folder_id client_file, templateable_type
    parent_folder = get_object_by_id root_folder_id

    create_alfresco_document(repository,
                             file_name,
                             "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                             contents,
                             file_name,
                             "Imported document", parent_folder)
  end

  def self.document_path(alfresco_document)
    parent_folder = alfresco_document.parents.first

    "#{parent_folder.path}/#{alfresco_document.name}"
  end

  def self.document_webdav_url(document_path)
    "#{AlfrescoConfig[:ms_word_webdav_uri]}#{document_path}"
  end

  def self.document_pdf_preview_url(alfresco_id)
    alfresco_id = alfresco_id.gsub(/;\d+\.\d+$/, '')

    "#{AlfrescoConfig[:pdf_preview_space_store_uri]}/#{alfresco_id}/content/thumbnails/pdf?c=force&noCache=#{Date.today.to_time.to_i}&a=true"
  end

  def self.delete_templated_document(alfresco_id, repository = nil)
    @repository = repository if repository
    repository = @repository

    if !repository
      repository = connect_to_alfresco
    end

    alfresco_templated_document = get_object_by_id alfresco_id

    delete_alfresco_document alfresco_templated_document

  rescue ObjectNotFound => e
    Rails.logger.error { "Unable to delete stored document with id: #{alfresco_id}" }
  end

  private
  def self.templated_document_folder_id(client_file, template_type_name)

    begin
      client_file_folder = client_file.get_alfresco_folder
    rescue ObjectNotFound
      client_file_folder = client_file.create_folder
    end

    folder_entity = "file_#{template_type_name.underscore}_folder".to_sym

    templated_document_folder = client_file_folder.child_by_name AlfrescoConfig[folder_entity]
    templated_document_folder.id

  end

  def self.document_name(document_template)
    "#{document_template.template_type.gsub("\s","_")}_#{document_template.to_s.gsub("\s","_")}_#{SecureRandom.hex(10)}.docx"
  end

  def self.render_contents_from_template(document_template, client_file, document_templateable, current_user)
    return DocumentTemplating::Template.create_templated_document_for_client_file(document_template, client_file, current_user) if document_templateable.nil?

    DocumentTemplating::Template.create_templated_document_for_templateable(document_template, document_templateable, current_user)
  end

  def self.check_repository!(repository)
    unless repository
      Rails.logger.error 'Unable to connect to document store repository'
      raise DocumentTemplatingError.new 'Unable to connect to document store repository'
    end
  end

  def self.check_document_template!(document_template)
    if document_template.nil? || document_template.template_file.nil? || !document_template.template_file.file?
      Rails.logger.error "Document Template (#{document_template}) not found"
      raise DocumentTemplatingError.new "Document Template (#{document_template}) not found"
    end
  end

  def self.get_repository(repository)
    @repository = repository if repository
    repository = @repository

    if !repository
      repository = connect_to_alfresco
    end
    repository
  end
end
