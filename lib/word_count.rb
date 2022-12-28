class WordCount

  def self.count_docx(docx_path)
    unless File.exist?(docx_path)
      raise "File not found #{docx_path}"
    end
    txt_file_name = "#{File.basename(docx_path,'.*')}.txt"

    if File.exist?(txt_file_name)
      File.delete(txt_file_name)
    end

    output = `libreoffice --headless --convert-to txt:Text #{docx_path} > /dev/null && wc -w < #{txt_file_name}`

    File.delete(txt_file_name)

    output.to_i
  end

end
