json.array!(@account_charge_items) do |account_charge_item|
  json.extract! account_charge_item, :id, :fee_amount, :outlay_amount, :narrative, :account_id, :chargeable_item_id, :chargeable_item_type
  json.url account_charge_item_url(account_charge_item, format: :json)
end
