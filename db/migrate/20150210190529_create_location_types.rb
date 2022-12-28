class CreateLocationTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :location_types do |t|
      t.string :name

      t.timestamps
    end

    add_column :locations, :location_type_id, :integer
  end
end
