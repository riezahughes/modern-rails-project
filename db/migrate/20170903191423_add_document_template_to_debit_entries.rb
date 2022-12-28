class AddDocumentTemplateToDebitEntries < ActiveRecord::Migration
  def change
    add_reference :debit_entries, :document_template, index: true, foreign_key: true
  end
end
