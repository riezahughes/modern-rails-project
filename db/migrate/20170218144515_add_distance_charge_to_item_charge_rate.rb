class AddDistanceChargeToItemChargeRate < ActiveRecord::Migration[4.2]
  def change
    add_column :item_charge_rates, :block_distance_miles, :integer
    add_money :item_charge_rates, :block_distance_charge
  end
end
