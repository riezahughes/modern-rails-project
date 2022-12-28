class AddDocumentTemplateToTemplatedDocuments < ActiveRecord::Migration
  def change
    add_reference :templated_documents, :document_template, index: true, foreign_key: true
  end
end
