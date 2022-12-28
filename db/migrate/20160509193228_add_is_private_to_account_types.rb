class AddIsPrivateToAccountTypes < ActiveRecord::Migration[4.2]
  def change
    add_column :account_types, :is_private, :boolean, default: false
  end
end
