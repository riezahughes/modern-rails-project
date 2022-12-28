json.array!(@witnesses) do |witness|
  json.extract! witness, :id, :cited, :witnessable, :witnessable_type
  json.url witness_url(witness, format: :json)
end
