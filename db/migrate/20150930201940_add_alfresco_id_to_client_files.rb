class AddAlfrescoIdToClientFiles < ActiveRecord::Migration[4.2]
  def change
    add_column :client_files, :alfresco_id, :string
  end
end
