class TimeAndLine

  def self.account_charges(account)
    charges = []
    charge_rates = ChargeableItems::ItemRates.map_rates_by_item account.account_type

    AccountChargeables.account_chargeables(account) do |chargeable_items|
      item_charge_rate = ChargeableItems::ItemRates.charge_rate_for_item!(chargeable_items.first, charge_rates, account.account_type)

      charges += self.create_charges_from_items(chargeable_items,
       account,
       item_charge_rate)
    end
    charges
  end

  def self.create_charges_from_items(items, account, charge_rate)
    AccountChargeables.create_charges_from_items(items, account, charge_rate)
  end

end
