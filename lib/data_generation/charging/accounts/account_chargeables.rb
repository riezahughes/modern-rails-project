class AccountChargeables

  def self.account_chargeables(account)
    client_file = account.client_file
    AccountChargeable.classes.each do |chargeable_class|
      uncharged_items = chargeable_class.by_client_file(client_file).not_charged(account)
      yield uncharged_items unless uncharged_items.blank?
    end
  end

  def self.create_charges_from_items(items, account, charge_rate)
    calculator = ChargeableItems::ItemCharge.charge_calculator items.first
    return [] unless calculator

    items.map do |item|
      qualification_charge_rate = self.rate_by_item_user_qualification(charge_rate, item)

      raise MissingChargeRateError.new(item, account.account_type, item.qualification_type) unless qualification_charge_rate

      calculator.calculate_charge(item, account, qualification_charge_rate)
    end
  end

  private
  def self.rate_by_item_user_qualification(charge_rate, item)
    charge_rate[item.qualification_type]
  end

end
