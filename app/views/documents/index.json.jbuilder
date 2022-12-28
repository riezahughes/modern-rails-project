json.array!(@documents) do |document|
  json.extract! document, :id, :description, :documentable_id, :documentable_type
  json.url document_url(document, format: :json)
end
