class CreateAccounts < ActiveRecord::Migration[4.2]
  def change
    create_table :accounts do |t|
      t.date :effective_from
      t.date :effective_until
      t.date :feed_upto
      t.date :feed_date
      t.string :reference
      t.string :feed_status

      t.timestamps
    end
  end
end
