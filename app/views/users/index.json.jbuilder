json.array!(@users) do |user|
  json.extract! user, :id, :id_number, :access_code
  json.url user_url(user, format: :json)
end
