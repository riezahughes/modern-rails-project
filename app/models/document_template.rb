class DocumentTemplate < ActiveRecord::Base

  include AlfrescoConnection
  include AlfrescoTemplate

  has_many :templated_documents, dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :name
  validates :name, format: { with: /\A[A-Za-z0-9_\-. ]*\z/, message: 'can only contain letters, numbers, spaces and the following characters: _ - .' }

  validates_inclusion_of :template_type, in: DocumentTemplateable.classes.map(&:name), allow_blank: true

  has_attached_file :template_file,
                    path: ":rails_root/storage/:rails_env/document_templates/:id/:style/:basename.:extension",
                    styles: { pdf: { format: "pdf", processors: [:docsplit_pdf] } }

  validates_attachment_presence :template_file
  validates_attachment_content_type :template_file, content_type: %w(application/zip application/msword application/vnd.ms-office application/vnd.openxmlformats-officedocument.wordprocessingml.document application/octet-stream)

  attr_accessor :document_errors

  def create_document

    unless @repository
      connect_to_alfresco
    end

    unless self.alfresco_id.blank?
      begin
        return DocumentStoreDocument.new(get_object_by_id self.alfresco_id)
      rescue ObjectNotFound
        self.update(alfresco_id: nil)
      end
    end

    Rails.logger.info "Alfresco Id is blank for #{name}, creating new document"

    begin
      object = create_template_document @repository, self, self.name
    rescue DocumentExists => e
      Rails.logger.info 'Document already exists'
      object = nil
      @document_errors = [] unless @document_errors
      @document_errors << e.message.lines.first
    end

    if object
      self.update(alfresco_id: object.cmis_object_id)
      DocumentStoreDocument.new object
    else
      Rails.logger.error 'Object not created, unable to create document in document store'
      @document_errors = [] unless @document_errors
      @document_errors << 'Unable to create document in document store'
      nil
    end
  end

  def to_s
    name
  end

end
