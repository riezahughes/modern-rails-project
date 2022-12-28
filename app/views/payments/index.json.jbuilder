json.array!(@payments) do |payment|
  json.extract! payment, :id, :payment_date, :fee_amount, :outlay_amount, :claim_id
  json.url payment_url(payment, format: :json)
end
