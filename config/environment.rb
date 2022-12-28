# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

ActiveRecord::Base.connection.execute "SET collation_connection = 'utf8_general_ci' "

if File.exist? Rails.root.join('VERSION')
    APP_VERSION = File.read(Rails.root.join('VERSION')) 
else
    APP_VERSION = 'Cannot determine version'
end
