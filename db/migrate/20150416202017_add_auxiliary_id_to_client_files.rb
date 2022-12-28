class AddAuxiliaryIdToClientFiles < ActiveRecord::Migration[4.2]
  def change
    add_column :client_files, :auxiliary_id, :integer
    add_index :client_files, :auxiliary_id, unique: true
  end
end
