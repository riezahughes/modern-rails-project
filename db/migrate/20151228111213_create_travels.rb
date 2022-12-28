class CreateTravels < ActiveRecord::Migration[4.2]
  def change
    create_table :travels do |t|
      t.string :origin
      t.string :destination
      t.integer :mileage
      t.money :parking_costs
      t.money :toll_costs
      t.money :other_costs
      t.references :journey
      t.foreign_key :journeys

      t.timestamps null: false
    end
  end
end
