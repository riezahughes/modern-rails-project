class DataImport::UserImport < DataImport::EntityImport

  ALL_USER_QUERY = 'SELECT * FROM ((Employee INNER JOIN Users ON Employee.ID = Users.Employee)
  INNER JOIN `Employee Type` ON `Employee`.`Type` = `Employee Type`.`ID`)'

  def initialize(database)
    @database = database
  end

  def get_entity
    get_employees
  end

  def get_entity_class
    User
  end

  def get_employees()
    @database.query ALL_USER_QUERY
  end

  def prepare_data(record)
    personal_details_data = {
        title: record["Title"],
        forename: record["Forename"],
        middlenames: record["Middlenames"],
        surname: record["Surname"],
        initials: record["Initials"]}

    personal_details = PersonalDetails.create(personal_details_data)

    {username: record["Username"],
     personal_details: personal_details,
     id_number: record["ID Number"],
     access_code: record["Access Code"],
     user_type: UserType.find_or_create_by!(name: record["Type"]),
     auxiliary_id: record["ID"],
     active: record["Active"],
     password: record['Password'],
     password_confirmation: record['Password']}
  end

  def skip_record(data)
    false
  end

  def create_model(data)
    User.new data
  end

  def get_duplicate(model)
    User.find_by_username model.username
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
    User.all.each do |user|
      user.personal_details.delete
    end

    User.delete_all
  end

end
