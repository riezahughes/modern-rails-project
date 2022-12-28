# config valid only for Capistrano 3.1
lock '3.6.0'

set :application, 'storelaw'
set :repo_url, 'git@bitbucket.org:sashman/storelaw.git'

set :deploy_user, 'deploy'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/secrets.yml config/alfresco.yml config/aws.yml config/mailer.yml config/import.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets tmp/data vendor/bundle public/system storage}
set :bundle_binstubs, nil

set :tests , [ "spec --exclude-pattern spec/{features}/**/*_spec.rb" ]

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
set :whenever_environment, ->{ fetch :stage, fetch(:rails_env, "production") }

set :backup_path, "/home/#{fetch(:deploy_user)}/Backup"

set :import_user, 'import'

set :resque_log_file, "log/resque.log"

# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
set(:config_files, %w(
  nginx.conf
  alfresco.example.yml
  import.example.yml
  mailer.example.yml
  database.example.yml
  aws.example.yml
  #log_rotation
  monit
  unicorn.rb
  unicorn_init.sh
))

# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc. The full_app_name variable isn't
# available at this point so we use a custom template {{}}
# tag and then add it at run time.
set(:symlinks, [
  {
    source: "nginx.conf",
    link: "/etc/nginx/sites-enabled/{{full_app_name}}"
  },
  {
    source: "unicorn_init.sh",
    link: "/etc/init.d/unicorn_{{full_app_name}}"
  },
  {
    source: "log_rotation",
   link: "/etc/logrotate.d/{{full_app_name}}"
  },
  {
    source: "monit",
    link: "/etc/monit/conf.d/{{full_app_name}}.conf"
  }
])

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# setup rvm.
set :rbenv_type, :system
set :rbenv_ruby, '2.3.1'
# set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_prefix, "env RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

set :executable_config_files, %w( unicorn_init.sh )

# remove the default nginx configuration as it will tend
# to conflict with our configs.
before 'deploy:setup_config', 'nginx:remove_default_vhost'
# reload nginx to it will pick up any modified vhosts from
# setup_config
after 'deploy:setup_config', 'nginx:reload'

# Restart monit so it will pick up any monit configurations
# we've added
after 'deploy:setup_config', 'monit:restart'

before 'bundler:install', 'deploy:rm_mingw32'

before "deploy", "deploy:run_tests"

after "deploy:restart", "resque:restart"

namespace :deploy do

  # desc 'Restart application'
  # task :restart do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     # Your restart mechanism here, for example:
  #     # execute :touch, release_path.join('tmp/restart.txt')
  #   end
  # end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc "Remove mingw32 extensions from Gemfile.lock to re-bundle under LINUX"
  task :rm_mingw32 do
    on roles :app do
      puts "    modifying Gemfile.lock ... removing mingw32 platform ext. before re-bundling on LINUX"
      execute :sed, "'s/-x86-mingw32//' #{release_path}/Gemfile.lock > #{release_path}/Gemfile.tmp && mv #{release_path}/Gemfile.tmp #{release_path}/Gemfile.lock"
      execute :sed, "-n '/PLATFORMS/ a\  ruby' #{release_path}/Gemfile.lock"
    end
  end

  desc 'Invoke a rake command on the remote server'
  task :invoke, [:command] => 'deploy:set_rails_env' do |task, args|
    on primary(:app) do
      within current_path do
        with :rails_env => fetch(:rails_env) do
          rake args[:command]
        end
      end
    end
  end

  desc "Create database and database user"
  task :create_mysql_database do
    ask :db_root_password, ''
    ask :db_name, "#{fetch(:application)}_#{fetch(:rails_env)}"
    ask :db_user, "#{fetch(:application)}"
    ask :db_pass, ''

    on primary fetch(:migration_role) do
      execute "mysql --user=root --host=127.0.0.1 --password=#{fetch(:db_root_password)} -e \"CREATE DATABASE IF NOT EXISTS #{fetch(:db_name)}\""
      execute "mysql --user=root --host=127.0.0.1 --password=#{fetch(:db_root_password)} -e \"GRANT ALL PRIVILEGES ON #{fetch(:db_name)}.* TO '#{fetch(:db_user)}'@'localhost' IDENTIFIED BY '#{fetch(:db_pass)}' WITH GRANT OPTION\""
    end
  end

  desc "Download a copy of the import datbase"
  task :get_import_db do
    ask :import_db_user, fetch(:import_user)
    ask :import_db_password, nil, echo: false

    on primary fetch(:migration_role) do
      execute "mysqldump -u #{fetch(:import_db_user)} -p#{fetch(:import_db_password)} import > import.sql"
      execute 'tar -cvzf import.sql.tgz import.sql'
      download! 'import.sql.tgz', 'import.sql.tgz'
    end
  end

  desc "Print a list of config files"
  task :config_files do
    puts fetch(:config_files)
  end

  desc "Write deployed version to file"
  task :write_version do
    on roles :app do
      within repo_path do
        version = `git describe --abbrev=0 --tags`.chomp
        upload! StringIO.new(version), "#{current_path}/VERSION"
      end
    end
  end

end

before "deploy:restart", "deploy:write_version"
