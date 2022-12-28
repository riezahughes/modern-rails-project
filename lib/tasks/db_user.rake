
namespace :db_user do
  desc 'Create local database user'
  task :create do
    config   = Rails.configuration.database_configuration
    host     = config[Rails.env]["host"]
    db_name  = config[Rails.env]["database"]
    db_user  = config[Rails.env]["username"]
    db_password  = config[Rails.env]["password"]
    puts 'Database root password:'
    db_root_password = STDIN.gets.chomp
    `mysql --user=root --password=#{db_root_password} -e \"CREATE DATABASE IF NOT EXISTS #{db_name}\"`
    `mysql --user=root --password=#{db_root_password} -e \"GRANT ALL PRIVILEGES ON #{db_name}.* TO '#{db_user}'@'localhost' IDENTIFIED BY '#{db_password}' WITH GRANT OPTION\"`
  end
end
