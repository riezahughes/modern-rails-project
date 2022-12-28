json.array!(@clients) do |client|
  json.extract! client, :id, :birth_date, :address, :postcode, :mobile_telephone, :home_telephone, :contact_telephone, :legal_aid_id, :prison_number, :additional_contact_information
  json.url client_url(client, format: :json)
end
