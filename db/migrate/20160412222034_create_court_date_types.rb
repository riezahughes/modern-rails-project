class CreateCourtDateTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :court_date_types do |t|
      t.string :name
      t.money :preparation

      t.timestamps null: false
    end
    add_index :court_date_types, :name, unique: true
  end
end
