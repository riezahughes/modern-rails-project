class CreateDocumentTemplates < ActiveRecord::Migration[4.2]
  def change
    create_table :document_templates do |t|
      t.string :alfresco_id
      t.string :name

      t.timestamps null: false
    end
  end
end
