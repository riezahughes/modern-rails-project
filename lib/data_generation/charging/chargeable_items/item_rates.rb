class ChargeableItems::ItemRates

  def self.map_rates_by_item(account_type)
    charge_rates = {}
    ItemChargeRate.where(account_type: account_type).each do |item_charge_rate|
      charge_rates[item_charge_rate.chargeable_item_name] = {} unless charge_rates[item_charge_rate.chargeable_item_name]
      charge_rates[item_charge_rate.chargeable_item_name][item_charge_rate.qualification_type] = item_charge_rate
    end
    charge_rates
  end

  def self.charge_rate_for_item!(item, charge_rates, account_type)
    class_name = item.class.name
    item_charge_rate = charge_rates[class_name]

    raise MissingChargeRateError.new(item, account_type, 'Qualified') unless item_charge_rate

    item_charge_rate
  end

end
