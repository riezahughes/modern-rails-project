namespace :docx do

  desc "Count words in a docx file"
  task :word_count, [:doc_path] => [:environment] do |t, args|

    puts WordCount.count_docx(args[:doc_path])

  end

end
