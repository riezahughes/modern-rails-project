json.array!(@disclosures) do |disclosure|
  json.extract! disclosure, :id, :client_file_id
  json.url disclosure_url(disclosure, format: :json)
end
