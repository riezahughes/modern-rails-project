class DataImport::DocFile
  require 'libreconv'

  @root_location = "/mnt"

  def self.read_file(location)

    location = decode_path(location)

    if File.extname(location) == '.doc'
      location = convert_to_docx_at_tmp_location(location)
    end

    File.read(location)
  end

  def self.file_name(location)
    File.basename(decode_windows_path(location)).gsub(/\.doc$/, '.docx')
  end

  def self.convert_to_docx_at_tmp_location(location)
    file_name = File.basename(location, ".doc")
    new_file_location = File.join(Rails.root.join('tmp'), "#{file_name}.docx")

    Rails.logger.info { "#{location} => #{new_file_location}" }
    Libreconv.convert(location, new_file_location, nil, 'docx')

    new_file_location
  end

  def self.convert_to_docx(doc_file)
    file_name = File.basename(doc_file, ".doc")
    new_file_dir = File.dirname doc_file
    new_file =  File.join(new_file_dir, "#{file_name}.docx")

    Libreconv.convert(doc_file, new_file, nil, 'docx')

    new_file
  end

  private
  def self.decode_path(path)
    "#{@root_location}#{decode_windows_path(path)}"
  end

  def self.decode_windows_path(path)
    path.gsub(/\\/,'/')
  end

end
