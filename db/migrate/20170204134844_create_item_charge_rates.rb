class CreateItemChargeRates < ActiveRecord::Migration[4.2]
  def change
    create_table :item_charge_rates do |t|
      t.string :chargeable_item_name
      t.string :qualification_type
      t.money :fixed_fee
      t.integer :initial_block_duration_mins
      t.money :initial_block_charge
      t.integer :block_duration_mins
      t.money :block_charge
      t.references :account_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
