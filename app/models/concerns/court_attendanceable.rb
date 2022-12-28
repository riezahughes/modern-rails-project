module CourtAttendanceable
  extend ActiveSupport::Concern

  included do
    has_one :court_attendance, as: :attendanceable, dependent: :destroy, autosave: true
    has_one :court_date, through: :court_attendance

    delegate :court_date, to: :court_attendance, prefix: false, allow_nil: true
    delegate :court_date_id, to: :court_attendance, prefix: false, allow_nil: true

    validates_presence_of :court_attendance
    validates_presence_of :court_date

    delegate :client_file, to: :court_attendance, allow_nil: true
    delegate :start_date, to: :court_attendance, allow_nil: true
    delegate :end_date, to: :court_attendance, allow_nil: true
    delegate :user, to: :court_attendance, allow_nil: true
    delegate :user_id, to: :court_attendance, allow_nil: true
  end

end
