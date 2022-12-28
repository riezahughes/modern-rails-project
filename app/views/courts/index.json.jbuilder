json.array!(@courts) do |court|
  json.extract! court, :id, :name, :address, :city, :telephone, :fax
  json.url court_url(court, format: :json)
end
