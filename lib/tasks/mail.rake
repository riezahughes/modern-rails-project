namespace :mail do

  desc 'Send a test email'
  task :test, [:email] => [:environment] do |t, args|

    email_to = args[:email]

    if email_to.blank?
      puts 'Must specify delivery email'
      next
    end

    TestMailer.test(email_to).deliver_now

  end

  desc 'Send notification summary emails'
  task notification_summary: :environment do
    summary_notifier = NotificationSummary.new
    summary_notifier.send_all
    summary_notifier.clear_all
  end

end
