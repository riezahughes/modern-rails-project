json.array!(@phone_calls) do |phone_call|
  json.extract! phone_call, :id, :attendance_with, :description, :chargeable, :client_file_id, :user_id
  json.url phone_call_url(phone_call, format: :json)
end
