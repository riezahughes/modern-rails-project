json.array!(@police_officers) do |police_officer|
  json.extract! police_officer, :id, :title, :name, :pc_number, :police_authority_id
  json.url police_officer_url(police_officer, format: :json)
end
