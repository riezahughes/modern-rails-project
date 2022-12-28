class ChargeableItems::AsyncItemCharge

  @queue = :charge_items

  def self.charge_items_under_account(items, account)
    if account.nil?
      Rails.logger.info "Trying to async item charge but no account given for items: #{items.map { |item| "item.to_s (item.id)" }.join(',')}"
      return
    end

    if items.blank?
      Rails.logger.warn "Trying ot async item charge but no items given for account: #{account}"
      return
    end

    item_id_types = items.map { |item| [item.id, item.class.name] }.to_h
    Resque.enqueue(self, item_id_types, account.id)

  rescue Redis::CannotConnectError => e
    Rails.logger.error { "Redis connection error: #{e}" }
  end

  def self.perform(item_id_types, live_account_id)
    items = item_id_types.map { |item_id, item_type| item_type.constantize.find item_id }
    live_account = Account.find live_account_id
    ChargeableItems::ItemCharge.charge_items_under_account items, live_account, live_account
  end

end
