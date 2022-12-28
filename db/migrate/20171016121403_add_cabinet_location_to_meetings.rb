class AddCabinetLocationToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :cabinet_location, :string
  end
end
