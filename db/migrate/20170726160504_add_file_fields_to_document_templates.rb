class AddFileFieldsToDocumentTemplates < ActiveRecord::Migration
  def up
    add_attachment :document_templates, :template_file
  end

  def down
    remove_attachment :document_templates, :template_file
  end
end
