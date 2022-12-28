class DataImport::FileFormImport < DataImport::EntityImport


  def initialize(database, import_helper = nil)
    @database = database
    @date_wrap_char = '\''
    @import_since_date = 2.year.ago.to_formatted_s(:db)
  end

  def get_entity_class
    FileForm
  end

  def get_entity
    get_form
  end

  def get_form
    @database.query "SELECT `Form`.`Date` AS `Date`,
                     `Form`.`Description` AS `Description`,
                     `Form`.`Length` AS `Length`,
                     `Form`.`Location` AS `Location`,
                     `Form`.`Chargeable` AS `Chargeable`,
                     `Form`.`Created By` AS `Created By`,
                     `File Form`.`File` AS `File`
                     FROM (Form INNER JOIN `File Form` ON `File Form`.`Form` = `Form`.ID)
                     WHERE `Form`.`Date` > #{@date_wrap_char}#{@import_since_date}#{@date_wrap_char}"
  end

  def prepare_data(record)
    {
        form_date: record['Date'],
        description: record['Description'],
        length: record['Length'],
        chargeable: record['Chargeable'],
        cabinet_location: record['Location'],
        created_by: User.find_by_username(record['Created By']),
        client_file: ClientFile.find_by_auxiliary_id(record['File'])
    }
  end

  def create_model(data)
    FileForm.new(data)
  end

  def skip_record(data)
    data[:client_file].nil?
  end

  def get_duplicate(model)
    model.client_file.file_forms.where(form_date: model.form_date, description: model.description).first
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
    FileForm.delete_all
  end

end
