class CreateProcuratorFiscals < ActiveRecord::Migration[4.2]
  def change
    create_table :procurator_fiscals do |t|
      t.string :name
      t.text :address
      t.string :telephone
      t.string :fax

      t.timestamps
    end

    add_column :client_files, :procurator_fiscal_id, :integer
    add_index :procurator_fiscals, :name, unique: true

  end
end
