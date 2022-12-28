class AddAttendanceWithToMeetings < ActiveRecord::Migration[4.2]
  def change
    add_column :meetings, :attendance_with, :string
  end
end
