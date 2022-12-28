module AccountChargeItemsHelper

  def charge_rate_description(account_charge_item)

    if manual_charge_item? account_charge_item
      'Manual charge with a fixed fee'
    else
      calculator = ChargeableItems::ItemCharge.charge_calculator account_charge_item.chargeable_item
      calculator.charge_rate_description(account_charge_item) if calculator
    end
  end

  def charge_rate_link(account_charge_item)

    if manual_charge_item? account_charge_item
      account_charge_rate = account_charge_item.account.account_type.account_charge_rate
      account_charge_rate_path(account_charge_rate)
    else
      item_charge_rate_path(account_charge_item.item_charge_rate)
    end
  end

  def has_item_charge_rate?(account_charge_item)
    !(account_charge_item.item_charge_rate.nil?)
  end

  private
  def manual_charge_item?(account_charge_item)
    account_charge_item.chargeable_item.nil? && !has_account_charge_rate?(account_charge_item)
  end

  def has_account_charge_rate?(account_charge_item)
    account_charge_item.account.account_type.account_charge_rate.nil?
  end
end
