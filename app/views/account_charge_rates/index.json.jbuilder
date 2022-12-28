json.array!(@account_charge_rates) do |account_charge_rate|
  json.extract! account_charge_rate, :id, :fixed_fee, :account_type_id
  json.url account_charge_rate_url(account_charge_rate, format: :json)
end
