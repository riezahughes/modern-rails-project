class DataImport::MeetingImport < DataImport::EntityImport


  def initialize(database, import_helper = nil)
    @database = database
    @date_wrap_char = '\''
    @import_since_date = 2.year.ago.to_formatted_s(:db)
  end

  def get_entity_class
    Meeting
  end

  def get_entity
    get_meetings
  end

  def get_meetings
     @database.query "SELECT `Meeting`.`Description` AS `Description`,
                            `Meeting`.`Locus` AS `Locus`,
                            `Meeting`.`Word Count` AS `Word Count`,
                            `File Meeting Type`.`Type` AS `File Meeting Type`,
                            `Meeting Type`.`Type` AS `Meeting Type`,
                            `Meeting`.`Created By` AS `Created By`,
                            COALESCE(`Witness`.File, `File Meeting`.File) AS `File`,
                            `Meeting`.`Journey` AS `Journey`,
                            `Meeting`.`Work` AS `Work`,
                            `Meeting`.`ID` AS `ID`,
                            `Meeting`.`Location` AS `Location`,
                            `Witness`.ID AS `Witness ID`
                     FROM Meeting
                      LEFT JOIN `File Meeting` ON `File Meeting`.`Meeting` = `Meeting`.ID
                      LEFT JOIN `Witness Meeting` ON `Witness Meeting`.`Meeting` = `Meeting`.ID
                      LEFT JOIN `Witness` ON `Witness Meeting`.Witness = `Witness`.ID
                      LEFT JOIN `File Meeting Type` ON `File Meeting Type`.`ID` = `File Meeting`.`With`
                      INNER JOIN `Meeting Type` ON `Meeting Type`.`ID` = `Meeting`.`Type`
                      WHERE `Meeting`.`Created On` > #{@date_wrap_char}#{@import_since_date}#{@date_wrap_char}"
  end

  def prepare_data(record)
    if record['Journey']
      journey = Journey.find_by_auxiliary_id(record['Journey'])
    else
      journey = nil
    end

    if record['Locus']
      record['Locus'] = record['Locus'].encode("UTF-8", :invalid=>:replace, :replace=>"?")
    end

    if record['Witness ID']
      witness = Witness.find_by_auxiliary_id(record['Witness ID'])
    else
      witness = nil
    end
    {
        description: record['Description'],
        locus: record['Locus'],
        length: record['Word Count'],
        attendance_with: record['File Meeting Type'],
        meeting_type: MeetingType.find_or_create_by(name: record['Meeting Type'].capitalize),
        created_by: User.find_by_username(record['Created By']),
        client_file: ClientFile.find_by_auxiliary_id(record['File']),
        journey: journey,
        work: Work.find_by_auxiliary_id(record['Work']),
        witness: witness,
        cabinet_location: record['Location'],
        auxiliary_id: record['ID']
    }
  end

  def create_model(data)
    Meeting.new(data)
  end

  def skip_record(data)
    data[:client_file].nil? || data[:work].nil?
  end

  def get_duplicate(model)
    work = model.work
    model.client_file.meetings.where(description: model.description, locus: model.locus, attendance_with: model.attendance_with)
    .joins("JOIN works ON works.workable_id = meetings.id AND
            works.workable_type = 'Meeting' AND
            works.id = #{work.id}")
    .first
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
    Meeting.delete_all
  end

end
