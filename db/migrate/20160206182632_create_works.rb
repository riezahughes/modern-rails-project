class CreateWorks < ActiveRecord::Migration[4.2]
  def change
    create_table :works do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :feed
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
