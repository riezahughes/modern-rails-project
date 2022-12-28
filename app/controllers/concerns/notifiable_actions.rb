module NotifiableActions
  extend ActiveSupport::Concern

  included do
    before_action :set_notifiable, only: [:register_for_notification, :unregister_for_notification]
  end

  def register_for_notification
    respond_to do |format|
      if @notifiable.register_for_notification
        format.html { redirect_to @notifiable }
      else
        format.html { redirect_to @notifiable, alert: 'Unable to register for notification' }
      end
    end
  end

  def unregister_for_notification
    respond_to do |format|
      if @notifiable.unregister_for_notification
        format.html { redirect_to @notifiable }
      else
        format.html { redirect_to @notifiable, alert: 'Unable to unregister for notification' }
      end
    end
  end

end