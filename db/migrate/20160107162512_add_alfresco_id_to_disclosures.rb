class AddAlfrescoIdToDisclosures < ActiveRecord::Migration[4.2]
  def change
    add_column :disclosures, :alfresco_id, :string
  end
end
