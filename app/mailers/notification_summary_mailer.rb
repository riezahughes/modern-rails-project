class NotificationSummaryMailer < ApplicationMailer
  default from: "notifications@shortlaw.com"

  def notification_summary(email, notifiables)
    @notifiables = notifiables
    @counts = notifiables_counts notifiables

    mail to: email, subject: 'ShortLaw Notification summary'

  end

  private
  def notifiables_counts(notifiables)
    counts = {}
    notifiables.each do |notifiable|
      counts[notifiable.class.name] ||= 0
      counts[notifiable.class.name] += 1
    end
    counts
  end

end
