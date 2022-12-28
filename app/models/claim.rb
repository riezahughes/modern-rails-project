class Claim < ActiveRecord::Base
  DATE_FORMAT = '%e %B %Y'.freeze

  belongs_to :account
  has_many :payments
  has_one :client_file, through: :account
  has_one :client, through: :client_file

  validates_presence_of :account
  validates_presence_of :claim_date
  validates_presence_of :amount_pennies
  validates_uniqueness_of :auxiliary_id, allow_blank: true
  validates_uniqueness_of :slab_registration_number, allow_blank: true

  monetize :amount_pennies

  delegate :formatted_identifier, to: :account, prefix: true, allow_nil: true

  after_save :update_account_status

  scope :part_payment, ->(_part_payment = true) {
    Claim.from(joins(:payments)
    .group(:claim_id)
    .having('claims.amount_pennies - (SUM(payments.fee_amount_pennies) + SUM(payments.outlay_amount_pennies)) > 0'), :claims)
  }

  ransacker :outstanding_sort do
    Arel.sql('claims.amount_pennies - (SUM(payments.fee_amount_pennies) + SUM(payments.outlay_amount_pennies))')
  end

  def self.ransackable_scopes(_auth_object = nil)
    [:part_payment, :problem]
  end

  def to_s
    "#{account.account_type} #{claim_date.strftime(DATE_FORMAT)}"
  end

  def formatted_claim_date
    claim_date.strftime(DATE_FORMAT)
  end

  def update_account_status
    account.update! feed_status: :feed
  end
end
