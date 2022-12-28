class CreatePayments < ActiveRecord::Migration[4.2]
  def change
    create_table :payments do |t|
      t.date :payment_date
      t.monetize :fee_amount
      t.monetize :outlay_amount
      t.references :claim, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
