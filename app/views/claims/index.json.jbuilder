json.array!(@claims) do |claim|
  json.extract! claim, :id, :claim_date, :amount, :accepted, :problem, :notes, :account_id
  json.url claim_url(claim, format: :json)
end
