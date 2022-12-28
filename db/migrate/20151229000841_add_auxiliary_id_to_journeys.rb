class AddAuxiliaryIdToJourneys < ActiveRecord::Migration[4.2]
  def change
    add_column :journeys, :auxiliary_id, :integer
    add_index :journeys, :auxiliary_id, unique: true
  end
end
