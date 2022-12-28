class CreateAccountIncreases < ActiveRecord::Migration[4.2]
  def change
    create_table :account_increases do |t|
      t.money :amount
      t.date :date_granted
      t.string :granted_by
      t.references :account, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
