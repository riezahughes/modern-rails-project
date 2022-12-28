class Journey < ActiveRecord::Base

  DATE_FORMAT = '%e %B %Y'
  TIME_FORMAT = '%l:%M %p'

  belongs_to :user
  has_many :travels, dependent: :destroy
  validates_associated :travels
  accepts_nested_attributes_for :travels
  has_many :works, through: :travels
  has_many :meetings, dependent: :nullify
  has_many :court_dates, dependent: :nullify
  has_many :meeting_client_files, through: :meetings, source: :client_file
  has_many :court_date_client_files, through: :court_dates, source: :client_file

  validates_presence_of :user
  validates :client_file_count, :numericality => { :greater_than_or_equal_to => 0 }, allow_blank: true

  def self.ransackable_scopes(auth_object = nil)
    [:journey_search_scope]
  end

  scope :journey_search_scope, ->(search) {
    unscoped.joins(:user)
        .joins('LEFT JOIN personal_details ON personal_details_id = personal_details.id')
        .joins('LEFT JOIN travels ON travels.journey_id = journeys.id')
        .joins('LEFT JOIN works ON (works.workable_id = travels.id AND works.workable_type = "Travel")')
        .group(:id)
        .where(
            unscoped
                .person_name_scope(search)
                .departure_date_search_scope(search)
                .where_values.join(' OR ')) #TODO: hack to chain all the where's with ors, this should be fixed with Rails 5's where().or.where() chaining
        .order('(SELECT t.departure_date FROM
                  (SELECT MIN(works.start_date) departure_date, journeys.id FROM journeys
                    JOIN travels ON travels.journey_id = journeys.id
                    JOIN works ON works.workable_id = travels.id AND works.workable_type = "Travel"
                    GROUP BY journeys.id) t WHERE t.id = journeys.id) DESC')
  }

  scope :person_name_scope, ->(search) {
    joins(:user)
    .joins('LEFT JOIN personal_details ON personal_details_id = personal_details.id')
    .where('UPPER(CONCAT(IFNULL(personal_details.title, ""),
          personal_details.forename,
          IFNULL(personal_details.middlenames, ""),
          personal_details.surname
          )) LIKE ?', "%#{search.upcase.gsub(/\s/, '%')}%")
  }

  scope :departure_date_search_scope, ->(search) {
    joins('LEFT JOIN travels ON travels.journey_id = journeys.id')
    .joins('LEFT JOIN works ON (works.workable_id = travels.id AND works.workable_type = "Travel")')
    .where('DATE(works.start_date) = ?', (Date.parse(search) rescue nil))
  }

  ransacker :user_name_sort do
    Arel.sql('(SELECT personal_details.forename FROM personal_details WHERE personal_details.id = users.personal_details_id)')
  end

  scope :duration_select, -> {
    select('journeys.*, (SELECT t_duration.duration FROM
              (SELECT MAX(works.end_date) - MIN(works.start_date) duration, journeys.id FROM journeys
                JOIN travels ON travels.journey_id = journeys.id
                JOIN works ON works.workable_id = travels.id AND works.workable_type = "Travel"
                GROUP BY journeys.id) t_duration WHERE t_duration.id = journeys.id) duration')
  }

  ransacker :duration_sort do
    Arel.sql('duration')
  end

  ransacker :departure_date_sort do
    Arel.sql('(SELECT t.departure_date FROM
              (SELECT MIN(works.start_date) departure_date, journeys.id FROM journeys
                JOIN travels ON travels.journey_id = journeys.id
                JOIN works ON works.workable_id = travels.id AND works.workable_type = "Travel"
                GROUP BY journeys.id) t WHERE t.id = journeys.id)')
  end

  ransacker :return_date_sort do
    Arel.sql('(SELECT t.return_date FROM
              (SELECT MAX(works.end_date) return_date, journeys.id FROM journeys
                JOIN travels ON travels.journey_id = journeys.id
                JOIN works ON works.workable_id = travels.id AND works.workable_type = "Travel"
                GROUP BY journeys.id) t WHERE t.id = journeys.id)')
  end

  def client_files
    (meeting_client_files + court_date_client_files).uniq
  end

  def duration
    local_return_date = return_date
    local_departure_date = departure_date

    return nil if local_return_date.nil? || local_departure_date.nil?
    local_return_date - local_departure_date
  end

  def departure_date
    works.minimum(:start_date)
  end

  def return_date
    works.maximum(:end_date)
  end

  def formatted_departure_date
    local_departure_date = departure_date

    return nil if local_departure_date.nil?
    local_departure_date.strftime("#{DATE_FORMAT} #{TIME_FORMAT}")
  end

  def formatted_return_date
    local_return_date = return_date

    return nil if local_return_date.nil?
    local_return_date.strftime("#{DATE_FORMAT} #{TIME_FORMAT}")
  end

  def formatted_dates
    local_departure_date = departure_date
    local_return_date = return_date

    return formatted_departure_date if local_return_date.nil?

    return formatted_return_date if local_departure_date.nil?

    return "#{local_departure_date.strftime("#{DATE_FORMAT}")} - #{local_return_date.strftime("#{DATE_FORMAT}")}" if local_departure_date.to_date != local_return_date.to_date

    "#{local_departure_date.strftime("#{DATE_FORMAT}")} #{local_departure_date.strftime("#{TIME_FORMAT}")} - #{local_return_date.strftime("#{TIME_FORMAT}")}"
  end

  def to_s
    formatted_identifier
  end

  def formatted_identifier
    "#{user.short_full_name} #{formatted_dates}"
  end

end
