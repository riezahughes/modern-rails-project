class Payment < ActiveRecord::Base
  belongs_to :claim
  has_one :account, through: :claim
  has_one :client_file, through: :account

  validates_presence_of :payment_date
  validates_presence_of :claim
  validates_presence_of :fee_amount_pennies
  validates_presence_of :outlay_amount_pennies
  validates_uniqueness_of :claim, scope: [:payment_date, :fee_amount_pennies, :outlay_amount_pennies]

  monetize :fee_amount_pennies
  monetize :outlay_amount_pennies

  after_save :set_claim_last_payment_on

  def set_claim_last_payment_on
    claim.update(last_payment_on: payment_date) if claim.last_payment_on.nil? || claim.last_payment_on < payment_date
  end
end
