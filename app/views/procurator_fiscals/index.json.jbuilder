json.array!(@procurator_fiscals) do |procurator_fiscal|
  json.extract! procurator_fiscal, :id, :name, :address, :telephone, :fax
  json.url procurator_fiscal_url(procurator_fiscal, format: :json)
end
