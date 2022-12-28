json.array!(@court_officials) do |court_official|
  json.extract! court_official, :id, :name
  json.url court_official_url(court_official, format: :json)
end
