class CreateCourtOfficials < ActiveRecord::Migration[4.2]
  def change
    create_table :court_officials do |t|
      t.string :name

      t.timestamps
    end

    add_column :court_types, :court_official_id, :integer
  end
end
