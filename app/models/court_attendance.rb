class CourtAttendance < ActiveRecord::Base
  include Workable
  include AccountChargeable

  belongs_to :court_date
  belongs_to :attendanceable, polymorphic: true, dependent: :destroy, autosave: true

  validates_presence_of :work
  validates_presence_of :court_date
  validates_uniqueness_of :attendanceable_id, scope: [:attendanceable_type], message: 'can only have one attendace', allow_nil: true
  validates :account_charge_items, length: { maximum: 1 }

  delegate :client_file, to: :court_date, allow_nil: true

  default_scope {
    joins(:work)
    .order('works.start_date asc')
  }

  scope :by_client_file, ->(client_file) {
    joins(:work)
    .joins(:court_date)
    .where('court_dates.client_file_id = ?', client_file.id)
  }

  def client_file=(client_file)
    court_date.update!(client_file: client_file)
  end

  def narrative
    "Attendance by #{user}, for #{court_date.court_date_type}, at #{court_date.court}
    #{attendanceable_type ? attendanceable_type.gsub('Attendance', '') : ''}: #{formatted_duration} (#{short_times})"
  end

  def charge_prior_to_effective_from?
    true
  end

  def to_s
    court_date
  end

end
