class AddUserIdToClientFiles < ActiveRecord::Migration[4.2]
  def change
    add_column :client_files, :user_id, :integer
  end
end
