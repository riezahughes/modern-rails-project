namespace :docx do

  desc "Convert doc to docx"
  task :convert, [:folder_path] => [:environment] do |t, args|

    Dir.glob("#{args[:folder_path]}/*.doc") do |doc_file|
      p doc_file
      docx_file = DataImport::DocFile.convert_to_docx doc_file
    end
  end

end
