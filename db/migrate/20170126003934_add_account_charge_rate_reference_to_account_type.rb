class AddAccountChargeRateReferenceToAccountType < ActiveRecord::Migration[4.2]
  def change
    add_reference :account_types, :account_charge_rate, index: true, foreign_key: true
  end
end
