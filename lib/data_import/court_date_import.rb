class DataImport::CourtDateImport < DataImport::EntityImport

  def initialize(database, import_helper = nil)
    @database = database
    @date_wrap_char = '\''
    @import_since_date = 2.year.ago.to_formatted_s(:db)
  end

  def get_entity_class
    CourtDate
  end

  def get_entity
    get_court_dates
  end

  def get_court_dates
    @database.query "SELECT `Hearing`.`ID` AS `ID`,
                            `Hearing`.`File` AS `File`,
                            `Court`.`Name` AS `Court`,
                            `Hearing`.`Date` AS `Date`,
                            `Hearing`.`Time` AS `Time`,
                            `Hearing Type`.`Type` AS `Type`,
                            `Hearing`.`Journey` AS `Journey`,
                            `Hearing`.`Created By` AS `Created By`,
                            `Hearing Type`.`Preparation` AS `Preparation`
    FROM ((Hearing INNER JOIN `Hearing Type` ON Hearing.`Type` = `Hearing Type`.ID) LEFT JOIN `Court` ON `Hearing`.Court = Court.ID)
    WHERE `Hearing`.`Date` > #{@date_wrap_char}#{@import_since_date}#{@date_wrap_char}
    AND `Hearing`.`Date` <= #{@date_wrap_char}#{(14.days.from_now).to_formatted_s(:db)}#{@date_wrap_char}"
  end

  def prepare_data(record)
    begin
      time = record['Time'] || Time.new(0)
      date_time = DateTime.new(record['Date'].to_date.year,
                               record['Date'].to_date.month,
                               record['Date'].to_date.day,
                               time.to_time.hour,
                               time.to_time.min,
                               time.to_time.sec)
    rescue
      date_time = nil
    end

    {
        client_file: ClientFile.find_by_auxiliary_id(record['File']),
        court: Court.find_by_name(record['Court']),
        court_date: date_time,
        court_date_type: CourtDateType.find_or_create_by(name: record['Type']) { |type| type.preparation = Monetize.parse(record['Preparation']) },
        journey: Journey.find_by_auxiliary_id(record['Journey']),
        created_by: User.find_by_username(record['Created By']),
        auxiliary_id: record['ID']
    }
  end

  def create_model(data)
    CourtDate.new(data)
  end

  def skip_record(data)
    data[:client_file].nil?
  end

  def get_duplicate(model)
    model.client_file.court_dates.where(court_date: model.court_date, court_date_type: model.court_date_type).first
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
    CourtDate.delete_all
  end

end
