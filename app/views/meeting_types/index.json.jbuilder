json.array!(@meeting_types) do |meeting_type|
  json.extract! meeting_type, :id, :name
  json.url meeting_type_url(meeting_type, format: :json)
end
