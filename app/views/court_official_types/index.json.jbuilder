json.array!(@court_official_types) do |court_official_type|
  json.extract! court_official_type, :id, :name
  json.url court_official_type_url(court_official_type, format: :json)
end
