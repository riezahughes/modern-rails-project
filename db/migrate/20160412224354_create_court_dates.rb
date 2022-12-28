class CreateCourtDates < ActiveRecord::Migration[4.2]
  def change
    create_table :court_dates do |t|
      t.datetime :court_date
      t.references :client_file, index: true, foreign_key: true
      t.references :court, index: true, foreign_key: true
      t.references :court_date_type, index: true, foreign_key: true
      t.references :journey, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
