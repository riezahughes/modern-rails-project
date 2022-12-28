class DataImport::ClientFileInformationImport < DataImport::EntityImport

  def initialize(database)
    @database = database
  end

  def get_entity
    @database.query 'SELECT * FROM `File Info`'
  end

  def get_entity_class
    ClientFileInformation
  end

  def get_client_file_information(id = nil)
    if id
      @database.query "SELECT * FROM `File Info` WHERE ID = #{id}"
    else
      get_entity
    end
  end

  def prepare_data(record)
    {name: record['Description']}
  end

  def skip_record(data)
    false
  end

  def create_model(data)
    ClientFileInformation.new data
  end

  def get_duplicate(model)
    ClientFileInformation.find_by_name model.name
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
    ClientFileInformation.delete_all
  end
end
