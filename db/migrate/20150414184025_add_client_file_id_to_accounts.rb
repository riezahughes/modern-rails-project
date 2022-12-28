class AddClientFileIdToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :client_file_id, :integer
  end
end
