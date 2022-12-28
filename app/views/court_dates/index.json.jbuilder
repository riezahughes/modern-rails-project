json.array!(@court_dates) do |court_date|
  json.extract! court_date, :id, :court_date, :client_file_id, :court_id, :court_date_type_id, :journey_id
  json.url court_date_url(court_date, format: :json)
end
