class CreateJourneys < ActiveRecord::Migration[4.2]
  def change
    create_table :journeys do |t|
      t.datetime :departure_date
      t.datetime :return_date

      t.timestamps null: false
    end
  end
end
