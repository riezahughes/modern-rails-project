class CourtDate < ActiveRecord::Base

  DATE_FORMAT = '%e %B %Y'
  TIME_FORMAT = '%l:%M %p'

  belongs_to :client_file
  has_one :client, through: :client_file
  belongs_to :court
  belongs_to :court_date_type
  belongs_to :journey
  belongs_to :created_by, class_name: 'User', foreign_key: :user_id
  has_many :court_attendances
  has_many :attendance_waitings, through: :court_attendances, source: :attendanceable, source_type: 'AttendanceWaiting'
  has_many :attendance_appearings, through: :court_attendances, source: :attendanceable, source_type: 'AttendanceAppearing'

  validates_presence_of :court_date
  validates_presence_of :client_file
  validates_presence_of :court
  validates_presence_of :court_date_type
  validates :court_date, uniqueness: {scope: [:client_file, :court_date_type]}

  delegate :file_number, to: :client_file, prefix: true, allow_nil: true
  delegate :formatted_identifier, to: :journey, prefix: true, allow_nil: true

  scope :upcoming, -> { where('court_date >= ?', DateTime.now).order(court_date: :asc) }
  scope :past, -> { where('court_date < ?', DateTime.now).order(court_date: :desc) }
  scope :court_date_search_scope, ->(search) {
    joins(:client_file)
    .joins(:court_date_type)
    .includes(:client_file)
    .includes(:court_date_type)
    .where(
        unscoped
            .where('client_files.file_number LIKE ?', "%#{search.upcase.gsub(/\s/, '%')}%")
            .where('court_date_types.name LIKE ?', "%#{search.upcase.gsub(/\s/, '%')}%")
            .where('court_date = ?', (search.to_date rescue ''))
            .where_values.join(' OR ')) #TODO: hack to chain all the where's with ors, this should be fixed with Rails 5's where().or.where() chaining
    .order(court_date: :desc)
  }

  def formatted_court_date
    court_date_time = Time.parse(court_date.to_s)
    if court_date_time == court_date_time.midnight
      court_date.strftime "#{DATE_FORMAT}"
    else
      court_date.strftime "#{DATE_FORMAT} #{TIME_FORMAT}"
    end
  end

  def to_s
    "#{court_date_type} #{formatted_court_date}"
  end

  def formatted_identifier
    "#{client_file} #{to_s}"
  end
end
