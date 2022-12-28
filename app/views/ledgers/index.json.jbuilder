json.array!(@ledgers) do |ledger|
  json.extract! ledger, :id, :date_paid, :reference, :amount, :balance
  json.url ledger_url(ledger, format: :json)
end
