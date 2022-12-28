class CreateDisclosures < ActiveRecord::Migration[4.2]
  def change
    create_table :disclosures do |t|
      t.references :client_file, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
