class AddLastPaymentOnToClaims < ActiveRecord::Migration
  def change
    add_column :claims, :last_payment_on, :date
  end
end
