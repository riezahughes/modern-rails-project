class CreateClientFileTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :client_file_types do |t|
      t.string :name
      t.string :prefixes
      t.string :folder_colour

      t.timestamps
    end

    add_column :client_files, :client_file_type_id, :integer
  end
end
