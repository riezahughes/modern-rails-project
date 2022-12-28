class AddFileFieldsToDebitEntries < ActiveRecord::Migration
  def up
    add_attachment :debit_entries, :templated_document
  end

  def down
    remove_attachment :debit_entries, :templated_document
  end
end
