class CreateTemplatedDocuments < ActiveRecord::Migration[4.2]
  def change
    create_table :templated_documents do |t|
      t.string :alfresco_id
      t.string :document_path

      t.timestamps null: false
    end
  end
end
