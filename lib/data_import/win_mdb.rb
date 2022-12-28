class DataImport::WinMdb

  require 'win32ole'

  attr_accessor :mdb, :connection, :data, :fields, :catalog

  def initialize(mdb=nil)
    @mdb = mdb
    @connection = nil
    @data = nil
    @fields = nil
  end

  def open
    connection_string = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='
    #Access 2010 connection string
    # connection_string =  'Provider=Microsoft.ACE.OLEDB.12.0;Data Source='
    connection_string << "#{@mdb}"

    @connection = WIN32OLE.new('ADODB.Connection')
    @connection.Open(connection_string)

    @catalog = WIN32OLE.new("ADOX.Catalog")
    @catalog.ActiveConnection = @connection

    # catalog.create(connection_string)
    # Source="#{@mdb_file}"
  end

  def query(sql)
    recordset = WIN32OLE.new('ADODB.Recordset')
    # puts recordset.ole_methods
    recordset.Open(sql, @connection)
    # puts recordset.Fields
    @fields = []
    recordset.Fields.each do |field|
      @fields << field.Name
    end

    output = []
    begin
      @data = recordset.GetRows.transpose
      @data.each do |row|
        hash_row = Hash[row.each_with_index.map { |column, i| [@fields[i], column] }]
        output << hash_row
      end
    rescue
      @data = []
      output = []
    end
    recordset.Close
    output
  end

  def tables
    tables = []
    @catalog.tables.each { |t| tables << t.name if t.type == "TABLE" }
    tables
  end

  def execute(sql)
    @connection.Execute(sql)
  end

  def close
    @connection.Close
  end
end