class Ledger < ActiveRecord::Base

  DATE_FORMAT = '%e %B %Y'

  monetize :amount_in_pennies
  monetize :amount_out_pennies
  monetize :balance_pennies

  belongs_to :client

  validates_presence_of :date_paid
  validates_presence_of :narrative
  validates_presence_of :client

  delegate :full_name, to: :client, prefix: true, allow_nil: true

  ransacker :client_name_sort do
    Arel.sql('COALESCE(clients.company_name, (SELECT personal_details.forename FROM personal_details WHERE personal_details.id = clients.personal_details_id))')
  end

  def formatted_date_paid
    return '' if self.date_paid.blank?
    self.date_paid.strftime DATE_FORMAT
  end

end
