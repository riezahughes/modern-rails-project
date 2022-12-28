class CreateClientFileInformations < ActiveRecord::Migration[4.2]
  def change
    create_table :client_file_informations do |t|
      t.string :name

      t.timestamps
    end

    add_column :client_files, :client_file_information_id, :integer
    add_index :client_file_informations, :name, unique: true
  end
end
