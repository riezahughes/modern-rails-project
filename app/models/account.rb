class Account < ActiveRecord::Base
  DATE_FORMAT = '%e %B %Y'

  UPPERCASE_FILE_NUMBER_QUERY = 'client_files.file_number LIKE ?'
  UPPERCASE_ACCOUNT_TYPE_QUERY = 'account_types.name LIKE ?'

  scope :type_name, ->(name) { joins(:account_type).where("account_types.name = ?", name) }
  scope :feed, -> { where('feed_status = ? OR feed_date IS NOT NULL', 'feed') }
  scope :not_feed, -> { where('feed_status != ? AND feed_date IS NULL', 'feed') }
  scope :account_search_scope, ->(search) {
    unscoped
        .joins(:account_type).includes(:account_type)
        .joins(:client_file).includes(:client_file)
        .where(
            unscoped
                .where('client_files.file_number LIKE ?', "%#{search}%")
                .where('account_types.name LIKE ?', "%#{search}%")
                .where('effective_from = ?', (Date.parse(search) rescue nil))
                .where_values.join(' OR ')) #TODO: hack to chain all the where's with ors, this should be fixed with Rails 5's where().or.where() chaining
  }

  has_many :claims, dependent: :destroy
  has_many :account_increases, dependent: :destroy
  has_many :account_charge_items, dependent: :destroy
  belongs_to :client_file
  belongs_to :account_type
  belongs_to :nominated_solicitor, class_name: 'User'

  delegate :file_number, to: :client_file, prefix: true, allow_nil: true

  monetize :expenditure_limit_pennies
  monetize :expenditure_pennies

  def self.valid_statuses
    [
        :none,
        :current,
        :feed,
        :no_claim,
        :not_granted,
        :private
    ]
  end

  validates_presence_of :client_file
  validates_presence_of :account_type
  validates_uniqueness_of :auxiliary_id, allow_blank: true
  validates_inclusion_of :feed_status, in: self.valid_statuses.map(&:to_s), message: "Status must be one of: #{self.valid_statuses.map(&:to_s).join(', ')}"
  validates :expenditure_limit_pennies, numericality: {greater_than_or_equal_to: 0}
  validates :expenditure_pennies, numericality: {greater_than_or_equal_to: 0}

  before_save :add_account_file
  after_save :update_file_status, if: -> { feed_status_changed? }

  def add_account_file
    self.client_file.add_account! if self.client_file.no_account?
  end

  def update_file_status
    if feed? && !client_file.feed?
      self.client_file.fee!
    elsif client_file.feed?
      self.client_file.reopen!
    end
  end

  def feed?
    feed_status == 'feed'
  end

  def charge_item_fee_total
    Money.new Account.where(id: self.id)
    .joins(:account_charge_items).sum('account_charge_items.fee_amount_pennies')
  end

  def charge_item_outlay_total
    Money.new Account.where(id: self.id)
    .joins(:account_charge_items)
    .sum('account_charge_items.outlay_amount_pennies')
  end

  def expense_report_fee_total
    Money.new AccountChargeItem.where(account_id: self.id)
    .for_account_expenses_report(self.effective_from)
    .sum('account_charge_items.fee_amount_pennies')
  end

  def expense_report_outlay_total
    Money.new AccountChargeItem.where(account_id: self.id)
    .for_account_expenses_report(self.effective_from)
    .sum('account_charge_items.outlay_amount_pennies')
  end

  def charge_item_combined_total
    Money.new Account.where(id: self.id)
    .joins(:account_charge_items)
    .sum('account_charge_items.outlay_amount_pennies + account_charge_items.fee_amount_pennies')
  end

  def claimed_amount
    Money.new claims.sum(:amount_pennies)
  end

  def remaining_amount_to_claim
    [charge_item_combined_total - Money.new(claims.sum(:amount_pennies)), Money.new(0)].max
  end

  def to_s
    return "#{client_file} #{account_type} #{effective_from.strftime DATE_FORMAT}" if effective_from

    "#{client_file} #{account_type}"
  end

  def formatted_identifier
    to_s
  end

end
