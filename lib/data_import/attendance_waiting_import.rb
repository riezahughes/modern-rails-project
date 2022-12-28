class DataImport::AttendanceWaitingImport < DataImport::EntityImport
  def initialize(database, _import_helper = nil)
    @database = database
    @date_wrap_char = '\''
    @import_since_date = 2.year.ago.to_formatted_s(:db)
  end

  def get_entity_class
    AttendanceWaiting
  end

  def get_entity
    get_attendance_watings
  end

  def get_attendance_watings
    @database.query 'SELECT
      `Waiting Hearing`.`Hearing` AS `Hearing`,
      `Waiting Hearing`.`Work` AS `Work`
    FROM `Waiting Hearing`'
  end

  def prepare_data(record)
    court_date = CourtDate.find_by_auxiliary_id(record['Hearing'])
    work = Work.find_by_auxiliary_id(record['Work'])
    court_attendance = CourtAttendance.joins(:work).where('works.id = ?', work).find_or_create_by(court_date: court_date) do |court_attendance|
      court_attendance.work = work
    end
    {
      court_attendance: court_attendance
    }
  end

  def create_model(data)
    AttendanceWaiting.new(data)
  end

  def skip_record(data)
    data[:court_attendance].nil? || data[:court_attendance].court_date.nil? || data[:court_attendance].work.nil?
  end

  def get_duplicate(model)
    work = model.court_attendance.work
    model.court_date.attendance_waitings
    .joins(:court_attendance)
    .joins("JOIN works ON works.workable_id = court_attendances.id AND
     works.workable_type = 'CourtAttendance' AND
     works.id = #{work.id}").first
  end

  def update(original, new_data)
    original.update(new_data)
  end

  def create_new(model)
    model.court_attendance.attendanceable = model
    model.court_attendance.save && model.save
  end

  def on_import(model, record)
  end

  def delete_all
    AttedanceWaiting.destroy_all
  end
end
