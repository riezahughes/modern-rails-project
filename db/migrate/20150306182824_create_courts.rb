class CreateCourts < ActiveRecord::Migration[4.2]
  def change
    create_table :courts do |t|
      t.string :name
      t.text :address
      t.string :city
      t.string :telephone
      t.string :fax

      t.timestamps
    end

    add_column :client_files, :court_id, :integer
  end
end
