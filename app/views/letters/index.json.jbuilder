json.array!(@letters) do |letter|
  json.extract! letter, :id, :letter_date, :description, :length, :chargeable, :high_legal
  json.url letter_url(letter, format: :json)
end
