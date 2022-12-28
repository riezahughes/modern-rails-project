namespace :pdf do

  desc "Number disclosure pages, using existing settings"
  task :number_disclosure, [:id] => [:environment] do |t, args|

    disclosure = Disclosure.find(args[:id])
    unless disclosure
      puts 'Disclosure not found'
      next
    end

    puts "Total #{disclosure.do_numbering}"
  end

end
