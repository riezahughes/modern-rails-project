require 'benchmark'
namespace :data_import do

  desc "Import all records using AutocaseImport"
  task :all, [:file] => [:environment] do |t, args|
    ai = DataImport::AutocaseImport.new args[:file]
    puts Benchmark.measure { ai.import_all }
  end

  desc 'Import entity records using AutocaseImport'
  %w(user
    client
    client_file
    account
    court
    letter
    file_form
    meeting
    journey
    travel
    work
    phone_call
    court_date
    attendance_waiting
    attendance_appearing
    police_officer
    civilian
    claim
    payment
    precognition).each do |entity|
    task entity.to_sym, [:file] => [:environment] do |t, args|
      if args[:file]
        importer = DataImport::AutocaseImport.new Rails.root.join(args[:file])
      else
        importer = DataImport::AutocaseImport.new
      end

      importer.import entity
    end
  end
end
