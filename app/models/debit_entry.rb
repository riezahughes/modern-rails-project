class DebitEntry < ActiveRecord::Base
  include DocumentTemplateable
  belongs_to :client_file
  belongs_to :created_by, class_name: 'User'

  validates_presence_of :client_file
  validates_presence_of :debit_entry_date
  validates_presence_of :description
  validates_presence_of :payment_method

  monetize :vat_pennies
  monetize :amount_pennies
  monetize :total_pennies

  delegate :file_number, to: :client_file, prefix: true, allow_nil: true

  before_validation :calculate_total

  def self.valid_payment_methods
    ['BACS', 'Cheque', 'Cash', 'Postal Order', 'Money Order', 'Bank Draft']
  end

  def to_s
    "Debit Entry #{debit_entry_date}"
  end

  def to_template_values
    {
      description: description,
      debitEntryDate: debit_entry_date,
      vat: vat.to_s,
      amount: amount.to_s,
      total: total.to_s,
      paymentMethod: payment_method
    }
  end

  def calculate_total
    self.total = vat + amount
  end

end
