class AddDocumentTemplateableToTemplatedDocument < ActiveRecord::Migration
  def change
    add_reference :templated_documents, :document_templateable, polymorphic: true, index: {name: :index_templated_documents_on_templated_docs}
  end
end
