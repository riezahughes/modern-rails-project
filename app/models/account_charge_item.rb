class AccountChargeItem < ActiveRecord::Base
  DATE_FORMAT = '%e %B %Y'

  after_save :set_account_last_charged_on

  belongs_to :account
  belongs_to :chargeable_item, polymorphic: true
  belongs_to :item_charge_rate

  monetize :fee_amount_pennies
  monetize :outlay_amount_pennies

  validates_presence_of :narrative
  validates_presence_of :account
  validates_presence_of :item_charge_rate, if: :chargeable_item_id?
  validates_presence_of :item_date, if: :chargeable_item_id?

  scope :since_effective_from, ->(date) {
    where('item_date >= ?', date)
  }

  scope :for_account_expenses_report, ->(date) {
    where(
      unscoped
        .since_effective_from(date)
        .where('chargeable_item_type = ?', 'Travel')
        .where('chargeable_item_type = ?', 'CourtAttendance')
        .where_values.join(' OR '))
  }

  def formatted_item_date
    item_date.strftime("#{DATE_FORMAT}") if item_date
  end

  def set_account_last_charged_on
    account.update!(last_charged_on: updated_at) if account.last_charged_on.nil? || account.last_charged_on < updated_at
  end
end
