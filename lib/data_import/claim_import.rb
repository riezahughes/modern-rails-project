class DataImport::ClaimImport < DataImport::EntityImport


  def initialize(database, import_helper = nil)
    @database = database
    @date_wrap_char = '\''
    @import_since_date = 2.year.ago.to_formatted_s(:db)
  end

  def get_entity_class
    Claim
  end

  def get_entity
    get_claims
  end

  def get_claims
    @database.query "SELECT
        ID,
        Account,
        Date,
        Amount,
        Accepted,
        Problem,
        Notes
        FROM Claim
        WHERE `Claim`.`Date` > #{@date_wrap_char}#{@import_since_date}#{@date_wrap_char}"
  end

  def prepare_data(record)
    {
        account: Account.find_by_auxiliary_id(record['Account']),
        claim_date: record['Date'],
        amount: Monetize.parse(record['Amount']),
        accepted: record['Accepted'],
        problem: record['Problem'],
        notes: record['Notes'],
        slab_registration_number: slab_registration_number_from_notes(record['Notes']),
        auxiliary_id: record['ID']
    }
  end

  def create_model(data)
    Claim.new(data)
  end

  def skip_record(data)
    data[:account].nil?
  end

  def get_duplicate(model)
    model.account.claims.where(claim_date: model.claim_date).first
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
    Claim.delete_all
  end

  private
  def slab_registration_number_from_notes(notes)
    notes[/(REG\d+(\/1)?)/, 1]
  end

end
