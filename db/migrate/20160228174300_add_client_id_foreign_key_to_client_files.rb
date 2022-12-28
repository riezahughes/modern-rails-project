class AddClientIdForeignKeyToClientFiles < ActiveRecord::Migration[4.2]
  def change
    add_foreign_key :client_files, :clients
  end
end
