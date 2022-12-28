class AddClientFileIdToLetters < ActiveRecord::Migration[4.2]
  def change
    add_column :letters, :client_file_id, :integer
    add_index :letters, :client_file_id
  end
end
