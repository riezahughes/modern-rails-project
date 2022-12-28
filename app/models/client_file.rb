class ClientFile < ActiveRecord::Base

  include AASM
  include AlfrescoConnection
  include AlfrescoClientFile

  DATE_FORMAT = '%e %B %Y'

  belongs_to :created_by, class_name: 'User', foreign_key: 'user_id'
  belongs_to :client
  belongs_to :court
  belongs_to :procurator_fiscal
  belongs_to :current_solicitor, class_name: 'User', foreign_key: 'current_solicitor_id'
  belongs_to :partner, class_name: 'User', foreign_key: 'partner_id'
  belongs_to :client_file_information
  belongs_to :client_file_type
  has_many :accounts, dependent: :destroy
  has_many :letters, dependent: :destroy
  has_many :meetings, dependent: :destroy
  has_many :disclosures, dependent: :destroy
  has_many :phone_calls, dependent: :destroy
  has_many :court_dates, dependent: :destroy
  has_many :file_forms, dependent: :destroy
  has_many :debit_entries, dependent: :destroy
  has_many :witnesses, dependent: :destroy
  has_many :witnessables, through: :witnesses
  has_many :documents, as: :documentable

  validates_presence_of :file_number
  validates_uniqueness_of :file_number
  validates_presence_of :subject_matter
  validates_presence_of :client
  validates_presence_of :client_file_information
  validates_presence_of :client_file_type
  # validates_presence_of :disposal, if: :is_closed
  validates_uniqueness_of :auxiliary_id, allow_blank: true

  validate do |client_file|
    client_file.disclosures.each do |disclosure|
      next if disclosure.valid?
      disclosure.errors.full_messages.each do |msg|
        errors[:base] << "Disclosure Error: #{msg}"
      end
    end
  end

  before_save :update_status

  delegate :full_name, to: :client, prefix: true, allow_nil: true

  scope :with_file_number_prefix, ->(prefix) { where('file_number LIKE ?', "#{prefix}%") }
  scope :closed_files, -> { where('date_closed <= ?', Date.today) }
  scope :not_closed_files, -> { where(date_closed: nil) }
  scope :feed_files, -> { joins(:accounts).where('accounts.feed_status = ? OR accounts.feed_date IS NOT NULL', 'feed').uniq }

  enum file_status: {
           live: 1,
           feed: 2,
           closed_not_feed: 3,
           no_account: 4

       }

  aasm column: :file_status, enum: true do

    state :live
    state :feed
    state :closed_not_feed
    state :no_account, initial: true

    event :add_account do
      transitions from: :no_account, to: :live, guard: :is_not_closed
      transitions from: :no_account, to: :closed_not_feed, guard: :is_closed
      transitions from: :no_account, to: :feed, guard: :has_feed_account
    end

    event :fee do
      transitions from: [:live, :closed_not_feed], to: :feed
    end

    event :reopen do
      transitions from: [:feed, :closed_not_feed], to: :live
    end

    event :close do
      transitions from: :live, to: :closed_not_feed, guard: :is_closed
      transitions from: :no_account, to: :closed_not_feed
      transitions from: :feed, to: :feed
    end

    event :remove_accounts do
      transitions from: [:live, :closed_not_feed, :feed], to: :no_account
    end
  end

  def to_param
    file_number
  end

  def to_s
    file_number
  end

  def self.ransackable_scopes(auth_object = nil)
    [:client_file_search_scope]
  end

  scope :client_file_search_scope, ->(search) {
    joins(:client)
        .joins('LEFT JOIN personal_details ON personal_details.id = clients.personal_details_id')
        .where(
            unscoped.file_number_scope(search)
                .person_name_scope(search)
                .company_name_scope(search)
                .subject_matter_scope(search)
                .pf_reference_scope(search)
                .file_status_scope(search)
                .where_values.join(' OR ')) #TODO: hack to chain all the where's with ors, this should be fixed with Rails 5's where().or.where() chaining
  }

  scope :file_number_scope, ->(search) {
    where('UPPER(file_number) LIKE ?', "%#{search.upcase.gsub(/\s/, '%')}%")
  }

  scope :file_status_scope, ->(search) {
    where('UPPER(file_status) = ?', "#{ClientFile.file_statuses[search.downcase.gsub(/\s/, '_')]}")
  }

  scope :person_name_scope, ->(search) {
    joins(:client)
        .joins('LEFT JOIN personal_details ON personal_details.id = clients.personal_details_id')
        .where('UPPER(CONCAT(IFNULL(personal_details.title, ""),
          personal_details.forename,
          IFNULL(personal_details.middlenames, ""),
          personal_details.surname
          )) LIKE ?', "%#{search.upcase.gsub(/\s/, '%')}%")
  }

  scope :company_name_scope, ->(search) {
    joins(:client)
        .where('UPPER(clients.company_name) LIKE ?', "%#{search.upcase.gsub(/\s/, '%')}%")
  }

  scope :subject_matter_scope, ->(search) {
    where('UPPER(subject_matter) LIKE ?', "%#{search.upcase.gsub(/\s/, '%')}%")
  }

  scope :pf_reference_scope, ->(search) {
    where('UPPER(procurator_fiscal_reference) LIKE ?', "%#{search.upcase.gsub(/\s/, '%')}%")
  }

  ransacker :client_name_sort do
    Arel.sql('COALESCE(clients.company_name, (SELECT personal_details.forename FROM personal_details WHERE personal_details.id = clients.personal_details_id))')
  end

  def formatted_date_of_offence
    return '' if self.date_of_offence.blank?
    self.date_of_offence.strftime DATE_FORMAT
  end

  def formatted_date_open
    return '' if self.date_open.blank?
    self.date_open.strftime DATE_FORMAT
  end

  def formatted_date_closed
    return '' if self.date_closed.blank?
    self.date_closed.strftime DATE_FORMAT
  end

  def has_feed_account
    self.accounts.pluck(:feed_status).include? 'feed'
  end

  def is_local_agent_file
    client.local_agent?
  end

  def is_closed
    !self.date_closed.nil? && self.date_closed <= Date.today
  end

  def is_not_closed
    !is_closed
  end

  def feed_file_has_feed_account
    errors.add(:base, 'A feed file must have a least one feed account') if self.feed_status == 'feed' and !self.has_feed_account
  end

  def update_status
    close if !closed_not_feed? && self.is_closed
  end

  def next_court_date
    court_dates.upcoming.first
  end

  def most_recent_past_court_date
    court_dates.past.first
  end

  def next_court_date_by_court_date_type(court_date_type)
    court_dates.upcoming.where(court_date_type: court_date_type).first
  end

  def court_dates_to_be_changed
    upcoming_court_dates = court_dates.upcoming
    return [] unless upcoming_court_dates.any?

    court_dates = [upcoming_court_dates.first]

    following_court_date_type = court_dates.first.court_date_type.following_court_date_type
    if following_court_date_type
      following_court_dates = upcoming_court_dates.where(court_date_type: following_court_date_type)

      if following_court_dates.any?
        court_dates += following_court_dates
      end
    end

    court_dates
  end

  def get_alfresco_folder
    id = get_alfresco_id file_number

    if !(@repository.nil?) && id.nil?
      raise ObjectNotFound.new 'Folder has not been created yet'
    end

    object = get_object_by_id id
    if object
      DocumentStoreFolder.new object
    else
      nil
    end
  end

  def create_folder

    unless @repository
      connect_to_alfresco
    end

    begin
      object = create_file_folder @repository, self.file_number, "#{self.client.full_name}: #{self.subject_matter}", client
    rescue FolderExists
      object = get_object_by_id get_id_for_name(self.file_number)
    end

    if object
      self.update(alfresco_id: object.cmis_object_id)
      DocumentStoreFolder.new object
    else
      nil
    end
  end

  def last_disclosure_page
    return 0 if disclosures.empty?
    numbered_disclosures = disclosures.where.not(last_page: nil).maximum(:last_page)

    return 0 if numbered_disclosures.nil?
    numbered_disclosures
  end

end
