class AddTotalToDebitEntries < ActiveRecord::Migration
  def change
    add_monetize :debit_entries, :total
  end
end
