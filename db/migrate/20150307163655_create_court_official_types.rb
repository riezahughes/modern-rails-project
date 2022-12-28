class CreateCourtOfficialTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :court_official_types do |t|
      t.string :name

      t.timestamps
    end

    add_column :court_officials, :court_official_type_id, :integer
  end
end
