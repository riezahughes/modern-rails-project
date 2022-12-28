class CreateWitnesses < ActiveRecord::Migration[4.2]
  def change
    create_table :witnesses do |t|
      t.references :client_file, index: true, foreign_key: true
      t.references :witnessable, polymorphic: true, index: true
      t.boolean :cited

      t.timestamps null: false
    end
  end
end
