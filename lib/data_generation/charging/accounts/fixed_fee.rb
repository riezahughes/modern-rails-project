class FixedFee

  def self.account_charges(account)
    account_charge_rate = account.account_type.account_charge_rate

    raise ChargeCalculationError.new("Account Type #{account.account_type} has no account charge rate") if !account_charge_rate

    account_charge = account.account_charge_items.first_or_create! do |account_charge|
      account_charge.fee_amount = account_charge_rate.fixed_fee
      account_charge.narrative = 'Fixed Fee account charge'
      account_charge.account = account
    end
  end

  def self.create_charges_from_items(items, account, charge_rate)
     []
   end

end
