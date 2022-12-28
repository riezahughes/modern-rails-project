class AddAuxiliaryIdToWorks < ActiveRecord::Migration[4.2]
  def change
    add_column :works, :auxiliary_id, :integer
    add_index :works, :auxiliary_id, unique: true
  end
end
