json.array!(@client_file_informations) do |client_file_information|
  json.extract! client_file_information, :id, :name
  json.url client_file_information_url(client_file_information, format: :json)
end
