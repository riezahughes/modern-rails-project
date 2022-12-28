json.array!(@account_increases) do |account_increase|
  json.extract! account_increase, :id, :amount, :date_granted, :granted_by, :account_id
  json.url account_increase_url(account_increase, format: :json)
end
