module AccountsHelper

  def amount_for_expense_report(money_amount, account_charge_item, effective_from_date)
    return Money.new(0) if account_charge_item.item_date <= effective_from_date && !account_charge_item.chargeable_item.charge_prior_to_effective_from?

    money_amount
  end

end
