class DataImport::PoliceOfficerImport < DataImport::EntityImport

  def initialize(database)
    @database = database
  end

  def get_entity
    @database.query 'SELECT
     `Police Officer`.Title AS Title,
     `Police Officer`.Fullname AS Fullname,
     `Police Officer`.`PC Number` AS `PC Number`,
     Witness.File AS `File`,
     Witness.Selected AS `Selected`,
     `Police Authority`.Name AS `Police Authority`,
     `Witness`.ID AS ID
    FROM `Police Officer`
    JOIN `Police Witness` ON `Police Officer`.ID = `Police Witness`.`Police Officer`
    JOIN Witness ON `Police Witness`.`Witness` = Witness.ID
    JOIN `Police Authority` ON `Police Authority`.`ID` = `Police Officer`.`Police Station`'
  end

  def get_entity_class
    PoliceOfficer
  end

  def prepare_data(record)
    {
        client_file: ClientFile.find_by_auxiliary_id(record['File']),
        cited: record['Selected'],
        auxiliary_id: record['ID'],
        witnessable: PoliceOfficer.find_or_create_by(name: record['Fullname'], title: record['Title'], pc_number: record['PC Number']) do |police_officer|
          police_officer.police_authority = PoliceAuthority.find_by_name(record['Police Authority'])
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
    Witness.where(witnessable_type: 'PoliceOfficer').delete_all
  end
end
