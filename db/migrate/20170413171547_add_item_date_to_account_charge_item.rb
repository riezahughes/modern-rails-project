class AddItemDateToAccountChargeItem < ActiveRecord::Migration[4.2]
  def change
    add_column :account_charge_items, :item_date, :datetime
  end
end
