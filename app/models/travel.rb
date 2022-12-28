class Travel < ActiveRecord::Base
  include Workable
  include AccountChargeable

  belongs_to :journey
  belongs_to :travel_method

  validates_presence_of :journey
  validates_presence_of :origin
  validates_presence_of :destination
  validates_presence_of :travel_method
  validates :mileage, :numericality => {greater_than_or_equal_to: 0, allow_blank: true}

  monetize :parking_costs_pennies
  monetize :toll_costs_pennies
  monetize :other_costs_pennies

  delegate :formatted_identifier, to: :journey, prefix: true, allow_nil: true
  delegate :user, to: :journey, allow_nil: true
  delegate :client_files, to: :journey, allow_nil: true

  def self.ransackable_scopes(auth_object = nil)
    [:travel_search_scope]
  end

  scope :person_name_scope, ->(search) {
    joins(:journey)
        .joins('INNER JOIN users ON journeys.user_id = users.id')
        .joins('LEFT JOIN personal_details ON personal_details_id = users.personal_details.id')
        .where('UPPER(CONCAT(IFNULL(personal_details.title, ""),
              personal_details.forename,
              IFNULL(personal_details.middlenames, ""),
              personal_details.surname
              )) LIKE ?', "%#{search.upcase.gsub(/\s/, '%')}%")
  }

  scope :travel_search_scope, ->(search) {
    joins(:journey)
        .joins(:travel_method)
        .joins('INNER JOIN users ON journeys.user_id = users.id')
        .joins('LEFT JOIN personal_details ON personal_details.id = users.personal_details_id')
        .where(
            unscoped
                .person_name_scope(search)
                .where('UPPER(origin) LIKE ?', "%#{search.upcase}%")
                .where('UPPER(destination) LIKE ?', "%#{search.upcase}%")
                .where('UPPER(travel_methods.name) LIKE ?', "%#{search.upcase}%")
                .where_values.join(' OR ')) #TODO: hack to chain all the where's with ors, this should be fixed with Rails 5's where().or.where() chaining
  }

  scope :by_client_file, ->(client_file) {
    joins(:work)
    .joins(:journey)
    .joins("LEFT JOIN court_dates ON journeys.id = court_dates.journey_id")
    .joins("LEFT JOIN meetings ON journeys.id = meetings.journey_id")
    .where(
      unscoped
      .where('court_dates.client_file_id = ?', client_file.id)
      .where('meetings.client_file_id = ?', client_file.id)
      .where_values.join(' OR ') #TODO: hack to chain all the where's with ors, this should be fixed with Rails 5's where().or.where() chaining
    ).uniq
  }

  def charge
    if client_files
      client_files.each do |client_file|
        live_account = LiveAccount.for_client_file client_file
        ChargeableItems::AsyncItemCharge.charge_items_under_account [self], live_account
      end
    end
  end

  def client_file_count
    journey.client_file_count || client_files.count
  end

  def charge_prior_to_effective_from?
    true
  end

  def to_s
    "#{origin} - #{destination} #{formatted_start_date}"
  end

  def narrative
    "Travel #{origin} to #{destination}"
  end

end
