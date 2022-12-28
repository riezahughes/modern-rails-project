class NotificationSummary

  def send_all
    send_notifications(Notification.all)
  end

  def send_notifications(notifications)

    user_id_notifications_map(notifications).each do |user_id, notifiables|
      send_email(notifiables, user_id) unless notifiables.empty?
    end

  end

  def clear_all
    clear_notifications(Notification.all)
  end

  def clear_notifications(notifications)
    notifications.each { |notification| notification.destroy_entities }
  end

  def user_id_notifications_map(notifications)
    user_notifications = {}
    notifications.each do |notification|
      notification.users.each do |user|
        user_notifications[user.id] ||= []
        user_notifications[user.id] += notification.notifiables
      end
    end
    user_notifications
  end

  private
  def send_email(notifiables, user_id)
    email = User.find(user_id).email

    unless email.blank?
      NotificationSummaryMailer.notification_summary(email, notifiables).deliver
    end
  end

end