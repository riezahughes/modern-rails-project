json.array!(@civilians) do |civilian|
  json.extract! civilian, :id, :title, :name, :address, :telephone
  json.url civilian_url(civilian, format: :json)
end
