class AddFileStatusToClientFiles < ActiveRecord::Migration[4.2]
  def change
    add_column :client_files, :file_status, :integer
  end
end
