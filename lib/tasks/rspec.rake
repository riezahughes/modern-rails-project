namespace :spec do

  begin
    require 'rspec/core/rake_task'
    desc 'Run all specs in spec directory (excluding integration specs)'
    RSpec::Core::RakeTask.new(:no_feature) do |task|
      task.exclude_pattern = 'spec/{features}/**/*_spec.rb'
    end
  rescue LoadError
  end

end