class AddPartnerIdToClientFiles < ActiveRecord::Migration[4.2]
  def change
    add_column :client_files, :partner_id, :integer
  end
end
