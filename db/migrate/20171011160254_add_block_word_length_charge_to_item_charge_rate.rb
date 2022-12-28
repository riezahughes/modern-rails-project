class AddBlockWordLengthChargeToItemChargeRate < ActiveRecord::Migration
  def change
    add_column :item_charge_rates, :block_word_length, :integer
    add_money :item_charge_rates, :block_word_length_charge
  end
end
