json.array!(@debit_entries) do |debit_entry|
  json.extract! debit_entry, :id, :debit_entry_date, :description, :vat, :amount, :client_file_id
  json.url debit_entry_url(debit_entry, format: :json)
end
