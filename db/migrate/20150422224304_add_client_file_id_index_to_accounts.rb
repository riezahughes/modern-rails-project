class AddClientFileIdIndexToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_index :accounts, :client_file_id
  end
end
