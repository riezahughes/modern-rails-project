class AddAccountChargeTypeToAccountTypes < ActiveRecord::Migration[4.2]
  def change
    add_column :account_types, :account_charge_type, :string, default: 'TimeAndLine'
  end
end
