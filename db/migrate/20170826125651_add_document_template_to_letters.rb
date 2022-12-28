class AddDocumentTemplateToLetters < ActiveRecord::Migration
  def change
    add_reference :letters, :document_template, index: true, foreign_key: true
  end
end
