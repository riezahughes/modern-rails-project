class CreateAccountChargeRates < ActiveRecord::Migration[4.2]
  def change
    create_table :account_charge_rates do |t|
      t.money :fixed_fee

      t.timestamps null: false
    end
  end
end
