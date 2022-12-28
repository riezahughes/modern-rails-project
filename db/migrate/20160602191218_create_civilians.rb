class CreateCivilians < ActiveRecord::Migration[4.2]
  def change
    create_table :civilians do |t|
      t.string :title
      t.string :name
      t.text :address
      t.string :telephone

      t.timestamps null: false
    end
  end
end
