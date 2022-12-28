json.array!(@attendance_waitings) do |attendance_waiting|
  json.extract! attendance_waiting, :id, :work_id
  json.url attendance_waiting_url(attendance_waiting, format: :json)
end
