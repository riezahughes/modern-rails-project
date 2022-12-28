class CreateTravelMethods < ActiveRecord::Migration[4.2]
  def change
    create_table :travel_methods do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
