class CreateCourtTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :court_types do |t|
      t.string :name
      t.string :recipient

      t.timestamps
    end
  end

  add_column :courts, :court_type_id, :integer
end
