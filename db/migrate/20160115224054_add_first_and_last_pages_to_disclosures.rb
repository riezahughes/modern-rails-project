class AddFirstAndLastPagesToDisclosures < ActiveRecord::Migration[4.2]
  def change
    add_column :disclosures, :first_page, :integer
    add_column :disclosures, :last_page, :integer
  end
end
