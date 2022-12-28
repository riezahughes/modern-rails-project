class CreateAccountChargeItems < ActiveRecord::Migration[4.2]
  def change
    create_table :account_charge_items do |t|
      t.money :fee_amount
      t.money :outlay_amount
      t.text :narrative
      t.references :account, index: { name: 'account_charge_item_index' }, foreign_key: true
      t.references :chargeable_item, polymorphic: true, index: { name: 'chargeable_charge_index' }

      t.timestamps null: false
    end
  end
end
