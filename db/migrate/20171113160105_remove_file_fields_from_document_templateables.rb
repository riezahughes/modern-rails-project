class RemoveFileFieldsFromDocumentTemplateables < ActiveRecord::Migration

  DOCUMENT_TEMPLATEABLES = [:debit_entries, :file_forms, :letters, :meetings, :precognitions]

  def up
    DOCUMENT_TEMPLATEABLES.each { |document_templateable| remove_attachment document_templateable, :templated_document }

  end

  def down
    DOCUMENT_TEMPLATEABLES.each { |document_templateable| add_attachment document_templateable, :templated_document }
  end
end
