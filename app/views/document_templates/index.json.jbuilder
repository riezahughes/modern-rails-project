json.array!(@document_templates) do |document_template|
  json.extract! document_template, :id, :alfresco_id, :name
  json.url document_template_url(document_template, format: :json)
end
