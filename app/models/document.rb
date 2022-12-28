class Document < ActiveRecord::Base
  include AlfrescoConnection
  include AlfrescoDocument
  include AlfrescoFolder

  belongs_to :documentable, polymorphic: true
  belongs_to :created_by, class_name: 'User'

  validates_presence_of :documentable
  validates_presence_of :description

  has_attached_file :document_file,
                    path: ':rails_root/storage/:rails_env/documents/:id/:style/:basename.:extension'
  validates_attachment_presence :document_file
  validates_attachment_content_type :document_file, content_type: %w[application/zip
                                                                     application/pdf
                                                                     application/msword
                                                                     application/vnd.ms-office
                                                                     application/vnd.openxmlformats-officedocument.wordprocessingml.document
                                                                     application/octet-stream]

  before_destroy :delete_document

  def create_document
    connect_to_alfresco unless @repository

    unless @repository
      Rails.logger.error 'Unable to connect to document store repository'
    end

    unless document_file.file?
      message = "Document (#{self}) not found"
      Rails.logger.error message
    end

    document_contents = Paperclip.io_adapters.for(document_file).read

    object = create_alfresco_document(@repository,
                             document_file_file_name,
                             document_file_content_type,
                             document_contents,
                             document_file_file_name,
                             description, parent_folder(documentable))

    update!(alfresco_id: object.cmis_object_id)
  end

  def parent_folder(parent)
    begin
      parent_folder = parent.get_alfresco_folder
    rescue ObjectNotFound
      parent_folder = parent.create_folder
    end

    config_key = parent.model_name == 'ClientFile' ? :file_documents_folder : :client_documents_folder

    documents_folder = parent_folder.child_by_name AlfrescoConfig[config_key]

    unless documents_folder
      Rails.logger.warn "Unable to find documents folder '#{AlfrescoConfig[config_key]}' under '#{parent_folder.name}', creating..."
      documents_folder = DocumentStoreFolder.new(create_alfresco_folder(@repository, AlfrescoConfig[config_key], '', parent_folder.object))
    end
    documents_folder.object
  end

  def delete_document
    connect_to_alfresco unless @repository

    unless @repository
      Rails.logger.error 'Unable to connect to document store repository'
    end

    alfresco_document = get_object_by_id alfresco_id

    delete_alfresco_document alfresco_document if alfresco_document

  rescue ObjectNotFound => e
    Rails.logger.error { "Unable to delete stored document with id: #{alfresco_id}" }
  rescue
    Rails.logger.error { "Could not delete document: #{e}" }
  end

  def pdf_preview
    session_id = AlfrescoSite.get_session_id
    if document_file_content_type != 'application/pdf'
      url = document_pdf_preview_url
    else
      url = document_original_preview_url
    end

    Rails.logger.debug { url }

    open(url, 'Cookie' => "JSESSIONID=#{session_id}").read
  end

  def document_present?
    !document_file.nil?
  end

  def to_s
    description
  end

  def documentable_file_number
    return nil unless documentable_type == 'ClientFile'

    documentable.file_number
  end

  def documentable_full_name
    return nil unless documentable_type == 'Client'

    documentable.full_name
  end

  private
  def document_pdf_preview_url
    "#{AlfrescoConfig[:pdf_preview_space_store_uri]}/#{alfresco_id.gsub(/;\d+\.\d+$/, '')}/content/thumbnails/pdf?c=force&noCache=#{Date.today.to_time.to_i}&a=true"
  end

  def document_original_preview_url
    "#{AlfrescoConfig[:space_store_uri]}/#{alfresco_id.gsub(/;\d+\.\d+$/, '')}/#{document_file_file_name}?a=true"
  end

end
