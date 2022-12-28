class AddMissingLastChargedOnData < ActiveRecord::Migration[4.2]
  def up
    Account.includes(:account_charge_items).joins(:account_charge_items).where(last_charged_on: nil).each do |account|
      account.update!(last_charged_on: account.account_charge_items.maximum(:updated_at))
    end
  end

  def down
  end
end
