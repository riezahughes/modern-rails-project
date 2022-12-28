class AddItemChargeRateToAccountChargeItem < ActiveRecord::Migration[4.2]
  def change
    add_reference :account_charge_items, :item_charge_rate, index: true, foreign_key: true
  end
end
