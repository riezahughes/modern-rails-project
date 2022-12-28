json.array!(@jurisdictions) do |jurisdiction|
  json.extract! jurisdiction, :id, :name
  json.url jurisdiction_url(jurisdiction, format: :json)
end
