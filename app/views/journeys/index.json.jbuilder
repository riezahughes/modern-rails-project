json.array!(@journeys) do |journey|
  json.extract! journey, :id, :departure_date, :return_date
  json.url journey_url(journey, format: :json)
end
