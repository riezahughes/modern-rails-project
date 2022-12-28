class DataImport::LocationImport < DataImport::EntityImport

  def initialize(database)
    @database = database
  end

  def get_entity
    get_locations
  end

  def get_entity_class
    Location
  end

  def get_locations(location_id = nil)
    if location_id.nil?
      @database.query 'SELECT *, `Location Type`.Type as `Location Type` FROM `Location Held` INNER JOIN `Location Type` ON `Location Held`.Type = `Location Type`.ID'
    else
      @database.query "SELECT *, `Location Type`.Type as `Location Type` FROM `Location Held` INNER JOIN `Location Type` ON `Location Held`.Type = `Location Type`.ID WHERE `Location Held`.ID = #{location_id}"
    end
  end

  def prepare_data(record)
    location_type = LocationType.find_or_create_by!(name: record["Location Type"])
    {
        name: record["Name"],
        address: record["Address"],
        telephone: record["Tel"],
        location_type: location_type
    }
  end

  def skip_record(data)
    false
  end

  def create_model(data)
    Location.new data
  end

  def get_duplicate(model)
    Location.find_by_name model.name
  end

  def update(original, new_data)

  end

  def create_new(model)
    model.save
  end

  def on_import(model, record)

  end

  def delete_all
    Location.delete_all
    LocationType.delete_all
  end

end
