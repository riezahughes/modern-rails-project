class AddCreatedByToDebitEntries < ActiveRecord::Migration
  def change
    add_reference :debit_entries, :created_by, index: true
    add_foreign_key :debit_entries, :users, column: :created_by_id
  end
end
