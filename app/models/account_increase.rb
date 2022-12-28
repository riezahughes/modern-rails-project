class AccountIncrease < ActiveRecord::Base
  belongs_to :account

  monetize :amount_pennies

  belongs_to :account

  validates_presence_of :account
  validates_presence_of :date_granted
  validates_presence_of :granted_by
  validates_presence_of :amount

  after_save :update_account_expenditure

  def update_account_expenditure
    total_expenditure = account.account_increases.sum(:amount_pennies)
    account.update(expenditure_pennies: total_expenditure)
  end

end
