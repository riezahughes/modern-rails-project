class ChargeableItems::Calculators::LetterItem

  def self.calculate_charge(item, account, charge_rate)

    raise ChargeCalculationError.new "Fixed charge cannot be blank for #{self.name}" if charge_rate.fixed_fee.blank?
    raise ChargeCalculationError.new 'No Letter item given' unless item

    fixed_fee = Money.new(0)
    fixed_fee = charge_rate.fixed_fee if item.chargeable?

    AccountChargeItem.create!(fee_amount: fixed_fee,
     narrative: item.description,
     account: account,
     chargeable_item: item,
     item_charge_rate: charge_rate,
     item_date: item.letter_date)
  end

  def self.charge_rate_description(item)
    if item.chargeable_item.chargeable?
      "Letter fixed charge @ £#{item.item_charge_rate.fixed_fee}"
    else
      "Letter is not chargeable"
    end
  end

end
