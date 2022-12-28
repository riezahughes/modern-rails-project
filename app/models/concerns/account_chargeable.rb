module AccountChargeable
  extend ActiveSupport::Concern

  def self.classes
    Rails.application.eager_load!
    ActiveRecord::Base.descendants
        .select { |c| c.included_modules.include?(AccountChargeable) }
  end

  def self.qualification_types
    ['Qualified', 'Unqualified']
  end

  def qualification_type
    user_qualified? ? 'Qualified' : 'Unqualified'
  end

  def charge
    if self.valid?
      live_account = LiveAccount.for_client_file self.client_file
      ChargeableItems::AsyncItemCharge.charge_items_under_account [self], live_account
    else
      Rails.logger.warn "Cannot charge invalid #{self}, errors: #{self.errors.full_messages.join(', ')}"
    end
  end

  def account_charge_item
    account_charge_items.first
  end

  def charge_prior_to_effective_from?
    false
  end

  def narrative
    raise 'No narrative defined'
  end

  included do
    has_many :account_charge_items, dependent: :destroy, as: :chargeable_item

    scope :not_charged, ->(account) {
      where.not(id: AccountChargeItem.select('chargeable_item_id')
      .where(chargeable_item_type: name)
      .where(account: account)
      .where("`account_charge_items`.`chargeable_item_id` = `#{table_name}`.`id`"))
    }
  end

end
