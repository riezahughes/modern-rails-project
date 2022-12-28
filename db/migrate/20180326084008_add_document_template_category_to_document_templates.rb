class AddDocumentTemplateCategoryToDocumentTemplates < ActiveRecord::Migration
  def change
    add_column :document_templates, :category, :string
    add_index :document_templates, :category
  end
end
