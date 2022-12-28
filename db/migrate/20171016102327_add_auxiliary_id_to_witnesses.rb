class AddAuxiliaryIdToWitnesses < ActiveRecord::Migration
  def change
    add_column :witnesses, :auxiliary_id, :integer
    add_index :witnesses, :auxiliary_id
  end
end
