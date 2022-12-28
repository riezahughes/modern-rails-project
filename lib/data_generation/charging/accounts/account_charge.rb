class AccountCharge

  def self.valid_account_charge_types
    ['FixedFee', 'TimeAndLine']
  end

  def self.charge!(account)
    account_charge_type = account.account_type.account_charge_type

    account_charge = self.account_charge_class(account_charge_type)
    charges = account_charge.account_charges(account)
  end

  private
  def self.account_charge_class(name)
    name.constantize
  end

end
