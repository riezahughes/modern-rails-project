class AccountChargeRate < ActiveRecord::Base
  has_one :account_type

  monetize :fixed_fee_pennies

  validates :fixed_fee_pennies, :numericality => { :greater_than_or_equal_to => 0 }
end
