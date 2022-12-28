class CreateClaims < ActiveRecord::Migration[4.2]
  def change
    create_table :claims do |t|
      t.date :claim_date
      t.money :amount
      t.boolean :accepted, default: false
      t.boolean :problem, default: false
      t.string :notes
      t.references :account, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
