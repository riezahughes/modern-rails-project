class DataImport::AccountImport < DataImport::EntityImport


  def initialize(database, import_helper = nil)
    @database = database
    @helper = import_helper || DataImport::Helpers::Autocase::AccountImportHelper.new
  end

  def get_entity_name
    'Account'.pluralize
  end

  def get_entity
    get_accounts
  end

  def get_accounts
    @database.query 'SELECT
    `Effective From`,
    `Feed Upto`,
    `Effective Until`,
    `Feed Date`,
    `Reference`,
    `Feed Status`,
    `Nominated Solicitor`,
    `Type`,
    `Initial Expenditure Limit`,
    `Expenditure Limit`,
    `Expenditure`,
    `File`,
    `Account`.`ID` AS `ID`
    FROM Account INNER JOIN `Account Type` ON Account.`Fee Type` = `Account Type`.ID'
  end

  def prepare_data(record)
    account_type = AccountType.find_or_create_by(name: record['Type']) do |type|
      type.initial_expenditure_limit = Monetize.parse(record['Initial Expenditure Limit'])
    end
    {
        effective_from: record['Effective From'],
        feed_upto: record['Feed Upto'],
        effective_until: record['Effective Until'],
        feed_date: record['Feed Date'],
        reference: record['Reference'],
        feed_status: @helper.corrected_status(record['Feed Status']),
        nominated_solicitor: User.find_by_auxiliary_id(record['Nominated Solicitor']),
        account_type: account_type,
        expenditure_limit: Monetize.parse(record['Expenditure Limit']),
        expenditure: Monetize.parse(record['Expenditure']),
        client_file: ClientFile.find_by_auxiliary_id(record['File']),
        auxiliary_id: record['ID']
    }
  end

  def create_model(data)
    Account.new(data)
  end

  def skip_record(data)
    data[:client_file].nil?
  end

  def get_duplicate(model)
    model.client_file.accounts.where(effective_from: model.effective_from, auxiliary_id: model.auxiliary_id).type_name(model.account_type.name).first
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
    Account.delete_all
  end

end
