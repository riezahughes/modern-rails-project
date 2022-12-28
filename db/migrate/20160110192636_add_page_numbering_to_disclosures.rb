class AddPageNumberingToDisclosures < ActiveRecord::Migration[4.2]
  def change
    add_column :disclosures, :number_pages, :boolean
    add_column :disclosures, :skip_pages, :string
    add_column :disclosures, :skip_even, :boolean
    add_column :disclosures, :skip_odd, :boolean
  end
end
