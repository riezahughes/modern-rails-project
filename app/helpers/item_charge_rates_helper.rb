module ItemChargeRatesHelper

  def unqualified_item_charge_rate_copy(item_charge_rate)
    original = item_charge_rate.attributes
    original[:qualification_type] = 'Unqualified'
    original
  end

  def unqualified_item_charge_rate_exists?(item_charge_rate)
    ItemChargeRate.exists?(
      chargeable_item_name: item_charge_rate.chargeable_item_name,
      account_type: item_charge_rate.account_type,
      qualification_type: 'Unqualified')
  end

end
