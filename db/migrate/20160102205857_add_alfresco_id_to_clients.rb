class AddAlfrescoIdToClients < ActiveRecord::Migration[4.2]
  def change
    add_column :clients, :alfresco_id, :string
  end
end
