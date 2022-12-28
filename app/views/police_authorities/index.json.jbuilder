json.array!(@police_authorities) do |police_authority|
  json.extract! police_authority, :id, :name, :address, :city, :police_constable, :telephone
  json.url police_authority_url(police_authority, format: :json)
end
