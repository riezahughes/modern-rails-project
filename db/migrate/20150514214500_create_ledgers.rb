class CreateLedgers < ActiveRecord::Migration[4.2]
  def change
    create_table :ledgers do |t|
      t.date :date_paid
      t.string :narrative
      t.money :amount_in
      t.money :amount_out
      t.money :balance
      t.integer :client_id

      t.timestamps
    end
    
  end
end
