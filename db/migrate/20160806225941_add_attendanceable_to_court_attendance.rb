class AddAttendanceableToCourtAttendance < ActiveRecord::Migration[4.2]
  def change
    add_reference :court_attendances, :attendanceable, polymorphic: true, index: { name: 'attendanceable_index' }
  end
end
