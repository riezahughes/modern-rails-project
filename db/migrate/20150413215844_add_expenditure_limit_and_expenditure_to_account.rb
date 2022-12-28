class AddExpenditureLimitAndExpenditureToAccount < ActiveRecord::Migration[4.2]
  def change
    add_money :accounts, :expenditure_limit
    add_money :accounts, :expenditure
  end
end
