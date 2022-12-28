class CreateClientFiles < ActiveRecord::Migration[4.2]
  def change
    create_table :client_files do |t|
      t.string :file_number
      t.string :subject_matter
      t.string :locus
      t.datetime :date_of_offence
      t.datetime :date_open
      t.datetime :date_closed
      t.string :disposal
      t.string :procurator_fiscal_reference
      t.string :police_reference
      t.string :disc_location

      t.timestamps
    end
  end
end
