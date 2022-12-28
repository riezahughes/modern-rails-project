class CreateCourtAttendances < ActiveRecord::Migration[4.2]
  def change
    create_table :court_attendances do |t|
      t.references :court_date, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
