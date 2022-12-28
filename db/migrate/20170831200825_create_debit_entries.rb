class CreateDebitEntries < ActiveRecord::Migration[4.2]
  def change
    create_table :debit_entries do |t|
      t.date :debit_entry_date
      t.text :description
      t.money :vat
      t.money :amount
      t.references :client_file, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
