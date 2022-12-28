# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

#set :environment, "production"

set :output, {:error => "log/data_import_error.log", :standard => "log/data_import.log"}

case environment
when 'production'
  every :day, at: '11pm' do
    rake "data_import:all[tmp/data/autocase_dump.db]"
  end
  
  every :day, at: '12am' do
    rake "mail:notification_summary"
  end
  
  every :day, at: '9pm' do
    command "cd /home/deploy/Backup && bundle exec backup perform -t database_backup"
  end
end