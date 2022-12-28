class TemplatedDocument < ActiveRecord::Base

  belongs_to :document_templateable, polymorphic: true
  belongs_to :document_template
  validates_presence_of :document_path
  validates_presence_of :alfresco_id
  validates_presence_of :document_template

  after_destroy :destroy_file_in_store

  scope :orphaned, -> { where(document_templateable: nil)}
  scope :attached_to_documentable, -> { where.not(document_templateable: nil)}

  def document_url
    AlfrescoTemplatedDocument.document_webdav_url document_path
  end

  def document_pdf_perview_url
    AlfrescoTemplatedDocument.document_pdf_preview_url alfresco_id
  end

  def file_name
    File.basename(document_path)
  end

  def to_s
    document_path
  end

  def destroy_file_in_store
    AlfrescoTemplatedDocument.delete_templated_document alfresco_id
  end
end
