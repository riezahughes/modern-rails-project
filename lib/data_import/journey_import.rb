class DataImport::JourneyImport < DataImport::EntityImport


  def initialize(database, import_helper = nil)
    @database = database
    @date_wrap_char = '\''
    @import_since_date = 2.year.ago.to_formatted_s(:db)
  end

  def get_entity_class
    Journey
  end

  def get_entity
    get_journeys
  end

  def get_journeys
    @database.query "SELECT `Users`.`Username` AS `Username`,
                            `Journey`.`Date` AS `Date`,
                            `Journey`.`Departure Time` AS `Departure Time`,
                            `Journey`.`Return Date` AS `Return Date`,
                            `Journey`.`ID` AS `ID`
          FROM ((Journey
          INNER JOIN `Employee` ON `Journey`.`Employee` = `Employee`.`ID`)
          INNER JOIN `Users` ON `Users`.`Employee` = `Employee`.`ID`)
          WHERE `Journey`.`Date` > #{@date_wrap_char }#{@import_since_date}#{@date_wrap_char}"
  end

  def prepare_data(record)
    {
        user: User.find_by_username(record['Username']),
        auxiliary_id: record['ID']
    }
  end

  def create_model(data)
    Journey.new(data)
  end

  def skip_record(data)
    data[:user].nil?
  end

  def get_duplicate(model)
    model.user.journeys.where(auxiliary_id: model.auxiliary_id).first
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
    Journey.delete_all
  end

end
