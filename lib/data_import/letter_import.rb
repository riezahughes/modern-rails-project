class DataImport::LetterImport < DataImport::EntityImport


  def initialize(database, import_helper = nil)
    @database = database
    @date_wrap_char = '\''
    @import_since_date = 2.year.ago.to_formatted_s(:db)
  end

  def get_entity_class
    Letter
  end

  def get_entity
    get_letter
  end

  def get_letter
    @database.query "SELECT `Letter`.`Date` AS `Date`, `Letter`.`Description` AS `Description`,
                     `Letter`.`Length` AS `Length`,
                     `Letter`.`Chargeable` AS `Chargeable`,
                     `Letter`.`High Legal` AS `High Legal`,
                     `Letter`.`Created By` AS `Created By`,
                     `Letter`.`Location` AS `Location`,
                     `File Letter`.`File` AS `File`
                     FROM (Letter INNER JOIN `File Letter` ON `File Letter`.`Letter` = `Letter`.ID)
                     WHERE `Letter`.`Date` > #{@date_wrap_char}#{@import_since_date}#{@date_wrap_char}"
  end

  def prepare_data(record)
    {
        letter_date: record['Date'],
        description: record['Description'],
        length: record['Length'],
        chargeable: record['Chargeable'],
        high_legal: record['High Legal'],
        cabinet_location: record['Location'],
        created_by: User.find_by_username(record['Created By']),
        client_file: ClientFile.find_by_auxiliary_id(record['File'])
    }
  end

  def create_model(data)
    Letter.new(data)
  end

  def skip_record(data)
    data[:client_file].nil?
  end

  def get_duplicate(model)
    model.client_file.letters.where(letter_date: model.letter_date, description: model.description).first
  end

  def update(original, new_data)
    original.update(new_data)
  end

  def create_new(model)
    model.save
  end

  def on_import(model, record)

  end

  def delete_all
    Letter.delete_all
  end

end
