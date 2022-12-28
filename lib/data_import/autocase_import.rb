class DataImport::AutocaseImport

  MDB_DATE_CHAR = '#'
  SQL_DATE_CHAR = '\''

  def initialize(mdb_file = Rails.root.join('tmp/data/autocase_dump.db'))

    @date_char = ''

    # begin
    #   @database = DataImport::WinMdb.new mdb_file
    #   @date_char = MDB_DATE_CHAR
    # rescue LoadError
      @database = DataImport::MysqlConnector.new mdb_file
      @date_char = SQL_DATE_CHAR
    # end

    @database.open

  end

  def import_all
    import :user
    import :police_authority
    import :court_official
    import :procurator_fiscal
    # Court data needs changed
    # import :court
    import :client_file_information
    import :location
    import :client
    import :client_file
    import :account
    import :claim
    import :payment
    import :work
    import :letter
    import :file_form
    import :journey
    import :travel
    import :police_officer
    import :civilian
    import :meeting
    import :phone_call
    import :court_date
    import :attendance_waiting
    import :attendance_appearing
    import :precognition

  end

  def import(entity)

    begin
      importer = entity_import_class(entity).new @database
    rescue NameError
      raise "No importer for entity #{entity}"
    end

    importer.date_wrap_char = @date_char
    importer.import importer.get_entity
  end

  def entity_import_class(entity)
    "DataImport::#{entity.to_s.camelize}Import".constantize
  end

end
