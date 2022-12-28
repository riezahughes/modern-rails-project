class DataImport::TravelImport < DataImport::EntityImport


  def initialize(database, import_helper = nil)
    @database = database
  end

  def get_entity_class
    Travel
  end

  def get_entity
    get_travels
  end

  def get_travels
    @database.query "SELECT
          `Travel`.`Journey` AS `Journey`,
          `Travel Method`.`Type` AS `Type`,
          `Travel`.`Origin` AS `Origin`,
          `Travel`.`Destination` AS `Destination`,
          `Travel`.`Mileage` AS `Mileage`,
          `Travel`.`Parking` AS `Parking`,
          `Travel`.`Bridge` AS `Bridge`,
          `Travel`.`Cost` AS `Cost`,
          `Travel`.`Work` AS `Work`
          FROM (Travel
          INNER JOIN `Travel Method` ON `Travel`.`Method` = `Travel Method`.`ID`)"
  end

  def prepare_data(record)
    {
        journey: Journey.find_by_auxiliary_id(record['Journey']),
        travel_method: TravelMethod.find_or_create_by(name: record['Type']),
        origin: record['Origin'],
        destination: record['Destination'],
        mileage: record['Mileage'],
        parking_costs: Monetize.parse(record['Parking']),
        toll_costs: Monetize.parse(record['Bridge']),
        other_costs: Monetize.parse(record['Cost']),
        work: Work.find_by_auxiliary_id(record['Work'])
    }
  end

  def create_model(data)
    Travel.new(data)
  end

  def skip_record(data)
    data[:journey].nil?
  end

  def get_duplicate(model)
    model.journey.travels.where(origin: model.origin, destination: model.destination, travel_method: model.travel_method, mileage: model.mileage).first
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
    Travel.delete_all
  end

end
