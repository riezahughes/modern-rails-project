module ChargingControllerHelper
  extend ActiveSupport::Concern

  def handle_calculation_error(error, redirect, alert_message)
    logger.error error
    logger.error error.backtrace.first(10).join("\n")
    redirect_to redirect, alert: alert_message
  end

  def handle_missing_charge_rate_error(error, redirect)
    logger.error error
    logger.error error.backtrace.first(10).join("\n")
    redirect_to redirect,
     alert: "Charge rate missing for #{error.qualification_type} #{error.chargeable_item.to_s} #{error.account_type}, "\
      "#{view_context.link_to('create', item_charge_rates_path(item_charge_rate: error.creation_attributes), method: :post)}.",
    flash: { html_safe: true }
  end

  def handle_invalid_charge_rate_error(error, redirect)
    logger.error error
    logger.error error.backtrace.first(10).join("\n")
    redirect_to redirect,
     alert: "#{error.message} for #{error.charge_rate}, "\
      "#{view_context.link_to('view', error.charge_rate)}.",
    flash: { html_safe: true }
  end


end
