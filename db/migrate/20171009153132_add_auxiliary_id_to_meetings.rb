class AddAuxiliaryIdToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :auxiliary_id, :integer
    add_index :meetings, :auxiliary_id
  end
end
