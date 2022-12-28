json.array!(@accounts) do |account|
  json.extract! account, :id, :effective_from, :effective_until, :feed_upto, :feed_date, :feed_status
  json.url account_url(account, format: :json)
end
