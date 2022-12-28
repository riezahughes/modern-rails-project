class AddMeetingTypeIdToMeetings < ActiveRecord::Migration[4.2]
  def change
    add_column :meetings, :meeting_type_id, :integer
  end
end
