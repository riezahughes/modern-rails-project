module AccountTypesHelper

  def show_charge_rate_fixed_fee(account_type)
    account_type.account_charge_type == 'FixedFee'
  end
end
