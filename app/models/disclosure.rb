class Disclosure < ActiveRecord::Base

  include AlfrescoConnection
  include AlfrescoDisclosure
  include PageNumbering

  belongs_to :client_file

  validates_presence_of :client_file
  validates_format_of :skip_pages, with: /[0-9\,\-]+/, message: 'Skip pages must be page numbers separated by commas, or page ranges like 2-4', allow_blank: true
  validates_numericality_of :last_page, allow_blank: true
  validates_numericality_of :first_page, less_than_or_equal_to: :last_page, allow_blank: true

  before_destroy :delete_document

  has_attached_file :pdf_document,
                    path: ":rails_root/storage/:rails_env/attachments/:id/:style/:basename.:extension"
  attr_accessor :document_errors

  validates_attachment_content_type :pdf_document, content_type: ['application/pdf']

  def get_alfresco_object
    if self.alfresco_id
      begin
        DocumentStoreDocument.new(get_object_by_id self.alfresco_id)
      rescue ObjectNotFound
        self.update(alfresco_id: nil)
        nil
      end
    end
  end

  def create_document

    unless @repository
      connect_to_alfresco
    end

    if self.alfresco_id
      begin
        return DocumentStoreDocument.new(get_object_by_id self.alfresco_id)
      rescue ObjectNotFound
        self.update(alfresco_id: nil)
      end
    end

    begin
      object = create_disclosure_document @repository, self, "#{self.client_file.file_number}: #{self.client_file.subject_matter}", client_file
    rescue DocumentExists => e
      object = nil
      @document_errors = [] unless @document_errors
      @document_errors << e.message.lines.first
    end

    if object
      self.update(alfresco_id: object.cmis_object_id)
      DocumentStoreDocument.new object
    else
      nil
    end
  end

  def delete_document
    unless @repository
      connect_to_alfresco
    end

    document = nil
    if self.alfresco_id
      begin
        document = DocumentStoreDocument.new(get_object_by_id self.alfresco_id)
      rescue ObjectNotFound
        self.update(alfresco_id: nil)
      end
    end

    if document
      if document.delete
        self.update(alfresco_id: nil)
      end
    end
  end


  def get_alfresco_document
    unless @repository
      connect_to_alfresco
    end

    document = nil
    if @repository && self.alfresco_id
      begin
        document = DocumentStoreDocument.new(get_object_by_id self.alfresco_id)
      rescue ObjectNotFound
        self.update(alfresco_id: nil)
      end
    end

    document
  end

end

