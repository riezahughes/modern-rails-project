class DataImport::SqliteConnector

  def initialize(db=nil)
    @db = db
  end

  def open
    @sqlite_db = SQLite3::Database.open "#{@db}", results_as_hash: true
  end

  def query(sql)
    begin
      @sqlite_db.execute sql
    rescue SQLite3::SQLException => e
      Rails.logger.error "#{sql}"
      Rails.logger.error "#{e}"
      []
    end
  end

end