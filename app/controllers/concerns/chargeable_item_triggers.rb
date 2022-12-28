module ChargeableItemTriggers
  extend ActiveSupport::Concern

  included do
    after_action :trigger_charge, only: [:create]
  end

  private
  def trigger_charge
    unless @chargeable_item
      Rails.logger.warn 'Chargeable item has not been set'
    else
      Helpers::ChargeTriggerHelper.trigger_charge @chargeable_item
    end
  end
end
