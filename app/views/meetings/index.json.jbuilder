json.array!(@meetings) do |meeting|
  json.extract! meeting, :id, :description, :locus, :length
  json.url meeting_url(meeting, format: :json)
end
