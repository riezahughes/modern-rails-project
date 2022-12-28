class CreateLocations < ActiveRecord::Migration[4.2]
  def change
    create_table :locations do |t|
      t.string :name
      t.text :address
      t.string :telephone

      t.timestamps
    end

    add_column :clients, :location_id, :integer
  end
end
