class DataImport::CourtOfficialImport < DataImport::EntityImport

  def initialize(database)
    @database = database
  end

  def get_entity
    @database.query 'SELECT *, `Court Official Type`.Type as Type FROM `Court Official` INNER JOIN `Court Official Type` ON `Court Official`.Type = `Court Official Type`.ID'
  end

  def get_entity_class
    CourtOfficial
  end

  def prepare_data(record)
    court_official_type = CourtOfficialType.find_or_create_by!(name: record['Type'])

    {name: record['Name'],
     court_official_type: court_official_type}
  end

  def skip_record(data)
    false
  end

  def create_model(data)
    CourtOfficial.new data
  end

  def get_duplicate(model)
    CourtOfficial.find_by_name model.name
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
    CourtOfficial.delete_all
    CourtOfficialType.delete_all
  end
end
