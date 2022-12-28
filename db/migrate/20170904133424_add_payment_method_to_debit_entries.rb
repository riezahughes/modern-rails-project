class AddPaymentMethodToDebitEntries < ActiveRecord::Migration
  def change
    add_column :debit_entries, :payment_method, :string
  end
end
