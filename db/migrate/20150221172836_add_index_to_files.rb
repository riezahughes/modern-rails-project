class AddIndexToFiles < ActiveRecord::Migration[4.2]
  def change
    add_index :client_files, :file_number, unique: true
  end
end
