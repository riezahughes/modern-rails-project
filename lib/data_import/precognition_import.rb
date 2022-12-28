class DataImport::PrecognitionImport < DataImport::EntityImport

  def initialize(database, import_helper = nil)
    @database = database
    @date_wrap_char = '\''
    @import_since_date = 2.year.ago.to_formatted_s(:db)
  end

  def get_entity_class
    Precognition
  end

  def get_entity
    get_precognitions
  end

  def get_precognitions
     @database.query "SELECT
                        Precognition.`Date Framed` AS `Date Framed`,
                        Precognition.`Length` AS Length,
                        `Precognition Framing`.Meeting AS Meeting
                      FROM
                        Precognition
                        JOIN `Precognition Framing` ON `Precognition Framing`.Precognition = Precognition.ID
                      WHERE `Precognition`.`Date Framed` > #{@date_wrap_char}#{@import_since_date}#{@date_wrap_char}"
  end

  def prepare_data(record)
    {
        description: 'N/a',
        date_framed: record['Date Framed'],
        length: record['Length'],
        meeting: Meeting.find_by_auxiliary_id(record['Meeting'])
    }
  end

  def create_model(data)
    Precognition.new(data)
  end

  def skip_record(data)
    data[:meeting].nil?
  end

  def get_duplicate(model)
    Precognition.where(id: model.meeting_id).first
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
    Precognition.delete_all
  end

end
