class CreateLetters < ActiveRecord::Migration[4.2]
  def change
    create_table :letters do |t|
      t.datetime :letter_date
      t.text :description
      t.integer :length
      t.boolean :chargeable
      t.boolean :high_legal

      t.timestamps null: false
    end
  end
end
