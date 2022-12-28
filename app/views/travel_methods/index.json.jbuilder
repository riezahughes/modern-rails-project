json.array!(@travel_methods) do |travel_method|
  json.extract! travel_method, :id, :name
  json.url travel_method_url(travel_method, format: :json)
end
