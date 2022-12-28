class AddIndexToLocations < ActiveRecord::Migration[4.2]
  def change
    add_index :locations, :name, unique: true
  end
end
