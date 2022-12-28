json.array!(@client_files) do |client_file|
  json.extract! client_file, :id, :file_number, :subject_matter, :locus, :date_of_offence, :date_open, :date_closed, :disposal, :procurator_fiscal_reference, :police_reference, :disc_location
  json.url client_file_url(client_file, format: :json)
end
