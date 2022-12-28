class DataImport::CivilianImport < DataImport::EntityImport

  def initialize(database)
    @database = database
  end

  def get_entity
    @database.query 'SELECT
     `Civilian`.Title AS Title,
     `Civilian`.Fullname AS Fullname,
     `Civilian`.Address AS Address,
     `Civilian`.Tel AS Tel,
      Witness.File AS `File`,
      Witness.Selected AS `Selected`,
      `Witness`.ID AS ID
    FROM `Civilian`
    JOIN `Civillian Witness` ON `Civilian`.ID = `Civillian Witness`.`Civillian`
    JOIN Witness ON `Civillian Witness`.`Witness` = Witness.ID'
  end

  def get_entity_class
    Witness
  end

  def prepare_data(record)
    {
        client_file: ClientFile.find_by_auxiliary_id(record['File']),
        cited: record['Selected'],
        auxiliary_id: record['ID'],
        witnessable: Civilian.find_or_create_by(name: record['Fullname'], title: record['Title']) do |civilian|
          civilian.address = record['Address']
          civilian.telephone = record['Tel']
        end
    }
  end

  def skip_record(data)
    data[:client_file].nil?
  end

  def create_model(data)
    Witness.new data
  end

  def get_duplicate(model)
    Witness.where(client_file: model.client_file, witnessable_id: model.witnessable_id, witnessable_type: model.witnessable_type).first
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
    Witness.where(witnessable_type: 'Civilian').delete_all
  end
end
