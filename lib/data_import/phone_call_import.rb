class DataImport::PhoneCallImport < DataImport::EntityImport

  def initialize(database, import_helper = nil)
    @database = database
    @date_wrap_char = '\''
    @import_since_date = 2.year.ago.to_formatted_s(:db)
  end

  def get_entity_class
    PhoneCall
  end

  def get_entity
    get_phone_calls
  end

  def get_phone_calls
    @database.query "SELECT `Phone Call`.`Description` AS `Description`,
                            `Phone Call`.`With` AS `With`,
                            `Phone Call`.`Chargeable` AS `Chargeable`,
                            `Phone Call`.`Created By` AS `Created By`,
                            `Phone Call`.`File` AS `File`,
                            `Phone Call`.`Work` AS `Work`
                     FROM `Phone Call`
                     WHERE `Phone Call`.`Created On` > #{@date_wrap_char}#{@import_since_date}#{@date_wrap_char}"
  end

  def prepare_data(record)
    {
        description: record['Description'],
        attendance_with: record['With'],
        chargeable: record['Chargeable'],
        created_by: User.find_by_username(record['Created By']),
        client_file: ClientFile.find_by_auxiliary_id(record['File']),
        work: Work.find_by_auxiliary_id(record['Work'])
    }
  end

  def create_model(data)
    PhoneCall.new(data)
  end

  def skip_record(data)
    data[:client_file].nil?
  end

  def get_duplicate(model)
    model.client_file.phone_calls.where(description: model.description, attendance_with: model.attendance_with).first
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
    PhoneCall.delete_all
  end

end
