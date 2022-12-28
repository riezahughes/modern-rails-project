json.array!(@precognitions) do |precognition|
  json.extract! precognition, :id, :description, :meeting_id
  json.url precognition_url(precognition, format: :json)
end
