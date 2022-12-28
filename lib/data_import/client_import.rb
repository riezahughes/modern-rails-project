class DataImport::ClientImport < DataImport::EntityImport

  def initialize(database, import_helper = nil)
    @database = database
    @helper = import_helper || DataImport::Helpers::Autocase::ClientImportHelper.new
    @client_class = NilClass
  end

  def get_entity
    get_clients
  end

  def get_entity_class
    Client
  end

  def delete_all
    Client.destroy_all
  end


  def prepare_data(record)
    personal_details_data = {
        title: record['Title'],
        forename: record['Forename'],
        middlenames: record['Middlenames'],
        surname: record['Surname'],
        initials: get_initials_from_names(record['Forename'], record['Middlenames'], record['Surname'])}

    personal_details = PersonalDetails.new(personal_details_data)

    client_data = {created_by: User.find_by_username(record['Created By']),
                   personal_details: personal_details,
                   local_agent: @helper.is_local_agent(personal_details),
                   birth_date: record['Birthdate'],
                   address: record['Address'],
                   mobile_telephone: record['Tel_Mobile'],
                   home_telephone: record['Tel_Home'],
                   contact_telephone: record['Tel_Contact'],
                   legal_aid_id: record['Legal Aid ID'],
                   prison_number: record['Prison Num'],
                   location: Location.find_by_name(record['Location']),
                   auxiliary_id: record['ID']}
  end

  def skip_record(data)
    false
  end

  def create_model(data)

    @client_class = @helper.get_client_class_from_data(data)

    client = @client_class.new(@helper.correct_data_for_client(data))
    fix_prison_number(client)
    client
  end

  def get_duplicate(model)

    if model.local_agent?
      return @client_class.where(local_agent: true).first
    end

    @client_class.find_by_client_identifiers(model).order(created_at: :desc).first
  end

  def update(original, new_data)
    update_imported_client original, new_data
  end

  def create_new(model)
    model.save
  end

  def on_import(model, record)
  end

  private
  def get_clients
    @database.query 'SELECT Client.Title AS Title,
       Client.Forename        AS Forename,
       Client.Middlenames     AS Middlenames,
       Client.Surname         AS Surname,
       Client.Birthdate       AS Birthdate,
       Client.Address         AS Address,
       Client.Tel_Mobile      AS Tel_Mobile,
       Client.Tel_Home        AS Tel_Home,
       Client.Tel_Contact     AS Tel_Contact,
       Client.`Legal Aid ID`  AS `Legal Aid ID`,
       Client.`Prison Number` AS `Prison Num`,
       Client.`Created By`    AS `Created By`,
       Client.`Location`      AS `Location ID`,
       `Location Held`.`Name` AS `Location`,
       Client.ID              AS ID
        FROM   (Client
        LEFT JOIN `Location Held` ON Client.Location = `Location Held`.ID )'
  end

  def get_initials_from_names(forename, middlenames, surname)

    return '' if forename.blank? || surname.blank?

    unless middlenames.blank?
      "#{forename[0]}#{middlenames.split.collect { |m| m[0] }.join('')}#{surname[0]}"
    else
      "#{forename[0]}#{surname[0]}"
    end
  end

  def update_imported_client(existing_client, client_data)
    existing_personal_details = nil
    existing_client.personal_details if defined? existing_client.personal_details
    successful_update = existing_client.update(client_data)
    existing_personal_details.destroy! if existing_personal_details
    successful_update
  end

  def fix_prison_number(client)

    if client.legal_aid_id =~ /DG\d+/i
      client.prison_number = client.legal_aid_id.upcase.gsub('DG', '')
      client.legal_aid_id = ''
    end

  end

end
