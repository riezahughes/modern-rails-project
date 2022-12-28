class Helpers::ChargeTriggerHelper

  def self.trigger_charge(item)
    Rails.logger.info "Triggering charge for #{item} (#{item.id})"
    item.charge
  end

end
