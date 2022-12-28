json.array!(@file_forms) do |file_form|
  json.extract! file_form, :id, :form_date, :description, :chargeable, :created_by_id
  json.url file_form_url(file_form, format: :json)
end
