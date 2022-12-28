class DataImport::PaymentImport < DataImport::EntityImport


  def initialize(database, import_helper = nil)
    @database = database
    @date_wrap_char = '\''
    @import_since_date = 17.year.ago.to_formatted_s(:db)
  end

  def get_entity_class
    Payment
  end

  def get_entity
    get_payments
  end

  def get_payments
    @database.query "SELECT
        Claim,
        Date,
        Outlay,
        Fee
        FROM Payment
        WHERE `Payment`.`Date` > #{@date_wrap_char}#{@import_since_date}#{@date_wrap_char}"
  end

  def prepare_data(record)
    {
        claim: Claim.find_by_auxiliary_id(record['Claim']),
        payment_date: record['Date'],
        fee_amount: Monetize.parse(record['Fee']),
        outlay_amount: Monetize.parse(record['Outlay'])
    }
  end

  def create_model(data)
    Payment.new(data)
  end

  def skip_record(data)
    data[:claim].nil?
  end

  def get_duplicate(model)
    model.claim.payments.where(payment_date: model.payment_date,
                                fee_amount_pennies: model.fee_amount_pennies,
                                outlay_amount_pennies: model.outlay_amount_pennies).first
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
    Payment.delete_all
  end

end
