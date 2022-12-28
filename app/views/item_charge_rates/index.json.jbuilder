json.array!(@item_charge_rates) do |item_charge_rate|
  json.extract! item_charge_rate, :id, :chargeable_item_name, :qualification_type, :fixed_fee, :initial_block_duration_mins, :initial_block_charge, :block_duration_mins, :block_charge, :account_type_id
  json.url item_charge_rate_url(item_charge_rate, format: :json)
end
