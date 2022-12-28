class ChargeableItems::ItemCharge

  def self.charge_calculator(item)
    begin
      item_calculator_class_name = "ChargeableItems::Calculators::#{item.class.name}Item"
      calculator_class = item_calculator_class_name.constantize
    rescue NameError
      return nil
    end

    calculator_class
  end

  def self.charge_items_under_account(items, account, original_account)
    Rails.logger.info "Charging to account: #{account}, items: #{items.map(&:to_s).join(', ')}"
    account_charge_type = account.account_type.account_charge_type
    account_charge = self.account_charge_class(account_charge_type)
    charge_rates = ChargeableItems::ItemRates.map_rates_by_item account.account_type

    self.chargeable_items_by_class(items) do |chargeable_items|
      item_charge_rate = ChargeableItems::ItemRates.charge_rate_for_item!(chargeable_items.first, charge_rates, account.account_type)

      chargeable_items.first.transaction do

        self.charge_items_from_chargeable_items(chargeable_items, original_account).each do |original_charge_items|
          Rails.logger.info "Deleting #{original_charge_items.map(&:to_s).join(', ')}"
          original_charge_items.destroy_all
        end

        Rails.logger.info "Creating new charge for account: #{account}, items: #{chargeable_items.map(&:to_s).join(', ')}"
        charges = account_charge.create_charges_from_items(chargeable_items, account, item_charge_rate)

      end
    end
  end

  def self.chargeable_items_by_class(items)
    AccountChargeable.classes.each do |chargeable_class|
      chargeable_items = items.select { |item| item.class == chargeable_class }
      yield chargeable_items unless chargeable_items.blank?
    end
  end

  private
  def self.account_charge_class(name)
    name.constantize
  end

  def self.charge_items_from_chargeable_items(chargeable_items, original_account)
    (chargeable_items.map do |chargeable_item|
      if original_account
        chargeable_item.account_charge_items.where(account: original_account)
      else
        chargeable_item.account_charge_items
      end
    end).reject{ |account_charge_item| !account_charge_item }
  end

end
