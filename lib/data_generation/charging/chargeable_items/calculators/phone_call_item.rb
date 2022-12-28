class ChargeableItems::Calculators::PhoneCallItem

  def self.calculate_charge(item, account, charge_rate)
    fixed_fee = charge_rate.fixed_fee

    raise ChargeCalculationError.new "Fixed charge cannot be blank for #{self.name}" if fixed_fee.blank?
    raise ChargeCalculationError.new 'No Phone Call item given' unless item

    AccountChargeItem.create!(fee_amount: fixed_fee,
     narrative: item.narrative,
     account: account,
     chargeable_item: item,
     item_charge_rate: charge_rate,
     item_date: item.start_date)
  end

  def self.charge_rate_description(item)
    "Phone Call fixed charge @ £#{item.item_charge_rate.fixed_fee}"
  end
end
