class DataImport::PoliceAuthorityImport < DataImport::EntityImport

  def initialize(database)
    @database = database
  end

  def get_entity
    @database.query 'SELECT * FROM `Police Authority`'
  end

  def get_entity_class
    PoliceAuthority
  end

  def prepare_data(record)
    {name: record['Name'],
     address: record['Address'],
     city: record['City'],
     police_constable: record['Police Constable'],
     telephone: record['Tel']}
  end

  def skip_record(data)
    false
  end

  def create_model(data)
    PoliceAuthority.new data
  end

  def get_duplicate(model)
    PoliceAuthority.find_by_name model.name
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
    PoliceAuthority.delete_all
  end
end
