class AddTemplateTypeToDocumentTemplates < ActiveRecord::Migration
  def change
    add_column :document_templates, :template_type, :string
    add_index :document_templates, :template_type
  end
end
