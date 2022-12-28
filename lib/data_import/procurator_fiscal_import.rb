class DataImport::ProcuratorFiscalImport < DataImport::EntityImport

  def initialize(database)
    @database = database
  end

  def get_entity
    @database.query 'SELECT * FROM `Procurator Fiscal`'
  end

  def get_entity_class
    ProcuratorFiscal
  end

  def prepare_data(record)
    {name: record['Name'],
     address: record['Address'],
     telephone: record['Tel'],
     fax: record['Fax']}
  end

  def skip_record(data)
    false
  end

  def create_model(data)
    ProcuratorFiscal.new data
  end

  def get_duplicate(model)
    ProcuratorFiscal.find_by_name model.name
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
    ProcuratorFiscal.delete_all
  end
end
