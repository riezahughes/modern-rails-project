class AttendanceAppearing < ActiveRecord::Base
  include CourtAttendanceable

  validates :counsel, inclusion: { in: [ true, false ] }
end
