json.array!(@notifications) do |notification|
  json.extract! notification, :id, :entity
  json.url notification_url(notification, format: :json)
end
