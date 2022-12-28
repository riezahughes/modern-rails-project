class DataImport::MysqlConnector

  require 'mysql2'

  def initialize(db = nil)
    @import_config = YAML.load_file(Rails.root.join('config', 'import.yml'))[Rails.env]
  end

  def open
    @mysql_conn = Mysql2::Client.new host: @import_config['host'],
                                     port: @import_config['port'],
                                     username: @import_config['username'],
                                     password: @import_config['password'],
                                     database: @import_config['database']
  end

  def query(sql)
    begin
      @mysql_conn.query(sql)
    rescue Mysql2::Error => e
      Rails.logger.error "#{sql}"
      Rails.logger.error "#{e}"
      []
    end
  end

end