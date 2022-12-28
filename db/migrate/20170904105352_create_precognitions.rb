class CreatePrecognitions < ActiveRecord::Migration[4.2]
  def change
    create_table :precognitions do |t|
      t.text :description
      t.references :meeting, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
