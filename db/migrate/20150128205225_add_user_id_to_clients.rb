class AddUserIdToClients < ActiveRecord::Migration[4.2]
  def change
    add_column :clients, :user_id, :integer
  end
end
