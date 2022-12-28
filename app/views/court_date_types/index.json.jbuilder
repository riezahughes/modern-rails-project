json.array!(@court_date_types) do |court_date_type|
  json.extract! court_date_type, :id, :name, :preparation
  json.url court_date_type_url(court_date_type, format: :json)
end
