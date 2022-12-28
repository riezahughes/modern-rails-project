json.array!(@client_file_types) do |client_file_type|
  json.extract! client_file_type, :id, :name, :prefixes, :folder_colour
  json.url client_file_type_url(client_file_type, format: :json)
end
