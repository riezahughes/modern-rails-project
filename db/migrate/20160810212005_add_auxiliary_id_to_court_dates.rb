class AddAuxiliaryIdToCourtDates < ActiveRecord::Migration[4.2]
  def change
    add_column :court_dates, :auxiliary_id, :integer
    add_index :court_dates, :auxiliary_id
  end
end
