class AddDocumentTemplateToFileForms < ActiveRecord::Migration
  def change
    add_reference :file_forms, :document_template, index: true, foreign_key: true
  end
end
