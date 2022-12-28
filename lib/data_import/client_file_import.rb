class DataImport::ClientFileImport < DataImport::EntityImport

  BASE_ALL_FILES_QUERY = 'SELECT
		File.`File Number` AS `File Number`,
		File.`Created By` AS `Created By`,
		File.`Client` AS `Client`,
		File.`Subject Matter` AS `Subject Matter`,
		File.`Locus` AS `Locus`,
		File.`Date of Offence` AS `Date of Offence`,
		File.`Date Open` AS `Date Open`,
		File.`Closed Date` AS `Closed Date`,
		File.`Disposal` AS `Disposal`,
		File.`PF Reference` AS `PF Reference`,
		File.`Police Reference` AS `Police Reference`,
		File.`Disc Location` AS `Disc Location`,
		`File Info`.`Description` AS `Description`,
		File.ID                  AS `File ID`,
       Court.Name               AS `Court Name`,
       `Procurator Fiscal`.name AS `Procurator Fiscal Name`,
       `Partner Users`.Username AS `Partner`,
       `Solicitor Users`.Username AS `Solicitor`
      FROM (((((((File
        LEFT JOIN `Court`
                 ON File.Court = Court.ID)
        LEFT JOIN `Procurator Fiscal`
                ON File.`Procurator Fiscal` = `Procurator Fiscal`.ID)
        LEFT JOIN `File Info`
               ON File.`Information` = `File Info`.ID)
        LEFT JOIN `Employee` AS `Partner Employee`
               ON File.`Partner` = `Partner Employee`.ID)
        LEFT JOIN `Users` AS `Partner Users`
               ON `Partner Users`.Employee = `Partner Employee`.ID)
        LEFT JOIN `Employee` AS `Solicitor Employee`
               ON File.`Solicitor` = `Solicitor Employee`.ID)
        LEFT JOIN `Users` AS `Solicitor Users`
               ON `Solicitor Users`.Employee = `Solicitor Employee`.ID)'

  def initialize(database, file_number_helper = nil)
    @database = database
    @file_number_helper = file_number_helper || DataImport::Helpers::Autocase::FileNumberHelper.new
  end

  def get_entity_class
    ClientFile
  end

  def get_entity
    get_files
  end

  def prepare_data(record)
    {created_by: User.find_by_username(record['Created By']),
     client_file_type: @file_number_helper.get_client_file_type(record['File Number'].upcase),
     current_solicitor: User.find_by_username(record['Solicitor']),
     partner: User.find_by_username(record['Partner']),
     client: @parent || Client.find_by(auxiliary_id: record['Client']),
     court: Court.find_by_name(record['Court Name']),
     procurator_fiscal: ProcuratorFiscal.find_by_name(record['Procurator Fiscal Name']),
     file_number: record['File Number'].upcase,
     subject_matter: record['Subject Matter'],
     locus: record['Locus'],
     date_of_offence: record['Date of Offence'].blank? ? nil : record['Date of Offence'],
     date_open: record['Date Open'].blank? ? nil : record['Date Open'],
     date_closed: record['Closed Date'].blank? ? nil : record['Closed Date'],
     disposal: record['Disposal'],
     procurator_fiscal_reference: record['PF Reference'],
     police_reference: record['Police Reference'],
     disc_location: record['Disc Location'],
     client_file_information: ClientFileInformation.find_by_name(record['Description']),
     auxiliary_id: record['File ID']
    }
  end

  def create_model(data)
    ClientFile.new(data)
  end

  def skip_record(data)
    return true unless data[:client]

    false
  end

  def get_duplicate(model)
    ClientFile.find_by_file_number(model.file_number)
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
    ClientFile.delete_all
  end

  private
  def get_files
    @database.query BASE_ALL_FILES_QUERY
  end


end
