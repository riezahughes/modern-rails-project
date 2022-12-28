class AddFileFieldsToDisclosures < ActiveRecord::Migration[4.2]
  def change
    add_column :disclosures, :pdf_document_file_name, :string
    add_column :disclosures, :pdf_document_content_type, :string
    add_column :disclosures, :pdf_document_file_size, :integer
    add_column :disclosures, :pdf_document_updated_at, :datetime
  end
end
