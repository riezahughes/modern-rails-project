json.array!(@attendance_appearings) do |attendance_appearing|
  json.extract! attendance_appearing, :id, :court_attendance_id, :court_attendance_type, :work_id, :counsel
  json.url attendance_appearing_url(attendance_appearing, format: :json)
end
