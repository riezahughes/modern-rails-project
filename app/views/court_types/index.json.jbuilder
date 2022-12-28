json.array!(@court_types) do |court_type|
  json.extract! court_type, :id, :name, :recipient
  json.url court_type_url(court_type, format: :json)
end
