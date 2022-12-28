class AddAuxiliaryIdToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :auxiliary_id, :integer
    add_index :accounts, :auxiliary_id, unique: true
  end
end
