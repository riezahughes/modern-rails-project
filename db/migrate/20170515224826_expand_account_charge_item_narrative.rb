class ExpandAccountChargeItemNarrative < ActiveRecord::Migration[4.2]
  def up
    change_column :account_charge_items, :narrative, :text
end
def down
    change_column :account_charge_items, :narrative, :string
end
end
