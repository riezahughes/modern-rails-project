class AddClientIdToClientFiles < ActiveRecord::Migration[4.2]
  def change
    add_column :client_files, :client_id, :integer
  end
end
