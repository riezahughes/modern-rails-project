class DataImport::WorkImport < DataImport::EntityImport


  def initialize(database, import_helper = nil)
    @database = database
    @date_wrap_char = '\''
    @import_since_date = 2.year.ago.to_formatted_s(:db)
  end

  def get_entity_class
    Work
  end

  def get_entity
    get_works
  end

  def get_works
    @database.query "SELECT `Users`.`Username` AS `Username`,
                            `Work`.`Date` AS `Date`,
                            `Work`.`From` AS `From`,
                            `Work`.`Till` AS `Till`,
                            `Work`.`Feed` AS `Feed`,
                            `Work`.`ID` AS `ID`
          FROM ((`Work`
          INNER JOIN `Employee` ON `Work`.`Employee` = `Employee`.`ID`)
          INNER JOIN `Users` ON `Users`.`Employee` = `Employee`.`ID`)
          WHERE `Work`.`Date` > #{@date_wrap_char}#{@import_since_date}#{@date_wrap_char}
          AND `Work`.`Date` <= #{@date_wrap_char}#{(Date.today + 1).to_formatted_s(:db)}#{@date_wrap_char}"
  end

  def prepare_data(record)
    begin
      from_time = record['From'] || Time.new(0)
      start_date = DateTime.new(record['Date'].to_date.year,
                                record['Date'].to_date.month,
                                record['Date'].to_date.day,
                                from_time.to_time.hour,
                                from_time.to_time.min,
                                from_time.to_time.sec)
    rescue
      start_date = nil
    end

    begin
      till_time = record['Till'] || record['From'] || Time.new(0)
      end_date = DateTime.new(record['Date'].to_date.year,
                              record['Date'].to_date.month,
                              record['Date'].to_date.day,
                              till_time.to_time.hour,
                              till_time.to_time.min,
                              till_time.to_time.sec)
    rescue
      end_date = nil
    end

    {
        user: User.find_by_username(record['Username']),
        start_date: start_date,
        end_date: end_date,
        feed: record['Feed'] > 0,
        auxiliary_id: record['ID']
    }
  end

  def create_model(data)
    Work.new(data)
  end

  def skip_record(data)
    data[:user].nil?
  end

  def get_duplicate(model)
    Work.find_by_auxiliary_id(model.auxiliary_id)
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
    Work.delete_all
  end

end
