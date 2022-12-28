class AddUserIdToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :nominated_solicitor_id, :integer
  end
end
