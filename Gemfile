source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"
gem 'dotenv-rails', groups: [:development, :test]
# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4"

gem "mysql2", "~> 0.5.4"

# Use Sass to process CSS
gem "sassc-rails"

gem "uglifier", "~> 4.2"

gem "coffee-rails", "~> 5.0"

gem "jquery-rails", "~> 4.5"

gem "jquery-ui-rails", "~> 6.0"

gem "turbolinks", "~> 5.2"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

gem "sdoc", "~> 2.5"

gem 'capybara', :group => [:development, :test]
gem "capybara-webkit", :group => [:development, :test]
gem "headless", :group => [:development, :test]

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use sqlite3 as the database for Active Record
# gem "sqlite3", "~> 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :production do
# Use unicorn as the app server
  gem 'unicorn', '~> 4.9'
end

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem 'web-console'
  gem 'capistrano', '~> 3.4'
  # rails specific capistrano functions
  gem 'capistrano-rails', '~> 1.1.0'

  # integrate bundler with capistrano
  gem 'capistrano-bundler'

  # if you are using Rbenv
  gem 'capistrano-rbenv', "~> 2.0"

  # include helper tasks
  gem 'capistrano-cookbook', require: false

  gem 'capistrano-rails-console'

  gem "capistrano-resque", "~> 0.2.2", require: false

  gem 'seed_dump'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem 'devise'
gem 'will_paginate-bootstrap'
gem 'cancan'
gem 'money-rails'
gem 'aasm'
gem 'bootstrap-multiselect-rails'
gem 'factory_girl_rails', :require => false
gem 'database_cleaner'
gem 'ransack'
gem 'fastercsv', '>= 1.2.3', :require => 'faster_csv'
gem 'activemdb', '~> 0.2.2'
gem 'sqlite3'
gem 'whenever'
gem 'cmis-ruby'
gem 'jstree-rails-4'
gem 'rails4-autocomplete'
gem 'paperclip', github: 'thoughtbot/paperclip'
gem 'bootstrap-filestyle-rails'
gem 'combine_pdf'
gem 'mailgun_rails'
gem "best_in_place", git: "https://github.com/mmotherwell/best_in_place"
gem 'resque'
gem 'clipboard-rails'
gem 'sablon'
gem 'gelf'
gem 'lograge'
# gem 'docsplit-paperclip-processor', github: 'sashman/docsplit-paperclip-processor', branch: 'master'
gem 'pdfjs_viewer-rails'
gem 'libreconv'
gem 'd3-rails'
gem 'bootstrap-datepicker-rails'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'

gem "webrick", "~> 1.7"
