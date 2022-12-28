json.array!(@travels) do |travel|
  json.extract! travel, :id, :origin, :destination, :mileage, :parking_costs, :toll_costs, :other_costs, :journey
  json.url travel_url(travel, format: :json)
end
