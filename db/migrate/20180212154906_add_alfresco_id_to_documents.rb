class AddAlfrescoIdToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :alfresco_id, :string
  end
end
