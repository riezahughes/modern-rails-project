class AccountType < ActiveRecord::Base

  monetize :initial_expenditure_limit_pennies

  has_many :accounts
  belongs_to :account_charge_rate, dependent: :destroy
  has_many :item_charge_rates, dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_uniqueness_of :is_private, if: :is_private
  validates_presence_of :initial_expenditure_limit_pennies
  validates_inclusion_of :account_charge_type, in: AccountCharge.valid_account_charge_types, allow_nil: true
  validates :initial_expenditure_limit_pennies, numericality: { greater_than_or_equal_to: 0 }
  scope :private_account, -> { where(is_private: true) }

  ransacker :initial_expenditure_limit_pennies do
    Arel.sql("CONVERT(initial_expenditure_limit_pennies, CHAR(8))")
  end

  def prefix_array
    prefixes.split(',')
  end

  def to_s
    name
  end

end
