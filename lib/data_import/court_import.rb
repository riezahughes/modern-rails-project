class DataImport::CourtImport < DataImport::EntityImport

  def initialize(database)
    @database = database
  end

  def get_entity
    @database.query 'SELECT
    `Court`.Name as `Name`,
    `Court`.Address as `Address`,
    `Court`.Fax as `Fax`,
    `Court`.City as `City`,
    `Court Type`.Type as `Court Type`,
    `Court Type`.Recipient as `Recipient`,
    `Police Authority`.Name as `Police Authority Name`,
    `Court Official`.Name as `Court Official Name`
    FROM ((`Court` INNER JOIN `Court Type` ON Court.Type = `Court Type`.ID) LEFT JOIN `Court Official` ON `Court Type`.Official = `Court Official`.ID) LEFT JOIN `Police Authority` ON `Court`.`Nearest Police Station` = `Police Authority`.ID '
  end

  def get_entity_class
    Court
  end

  def prepare_data(record)
    court_type = CourtType.find_or_create_by!(name: record["Court Type"]) do |court_type|
      court_type.recipient = record['Recipient']
      court_type.court_official = CourtOfficial.find_by_name(record["Court Official Name"])
    end

    {name: record["Name"],
     address: record["Address"],
     city: record["City"],
     telephone: record["Tel"],
     fax: record["Fax"],
     court_type: court_type,
     police_authority: PoliceAuthority.find_by_name(record['Police Authority Name']) || PoliceAuthority.find_by_name('Tayside Police')
    }
  end

  def skip_record(data)
    false
  end

  def create_model(data)
    Court.new data
  end

  def get_duplicate(model)
    Court.find_by_name model.name
  end

  def update(original, new_data)
    original.update new_data
  end

  def create_new(model)
    model.save
  end

  def on_import(model, record)

  end

  def delete_all
    Court.delete_all
    CourtType.delete_all
  end
end
