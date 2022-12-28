class CreatePoliceOfficers < ActiveRecord::Migration[4.2]
  def change
    create_table :police_officers do |t|
      t.string :title
      t.string :name
      t.string :pc_number
      t.references :police_authority, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
