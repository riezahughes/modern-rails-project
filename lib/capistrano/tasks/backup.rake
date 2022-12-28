namespace :backup do

  desc "Upload backup config files."
  task :upload_config do
    on roles(:app) do
      execute "mkdir -p #{fetch(:backup_path)}/models"
      execute "mkdir -p #{fetch(:backup_path)}/log"
      upload! StringIO.new(File.read("config/backup/Gemfile")), "#{fetch(:backup_path)}/Gemfile"
      upload! StringIO.new(File.read("config/backup/config.rb")), "#{fetch(:backup_path)}/config.rb"
      model_with_stage = File.read("config/backup/models/database_backup.rb").gsub(/stage\s*=\s*'.*'/, "stage='#{fetch(:stage)}'")
      upload! StringIO.new(model_with_stage), "#{fetch(:backup_path)}/models/database_backup.rb"
    end
  end
  
  desc "Install depencies required by backup."
  task :install_dependencies do
    on roles(:app) do
      within "#{fetch(:backup_path)}" do
        execute :bundle, "install"
      end
    end
  end

end