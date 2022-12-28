class AddLastChargedOnToAccount < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :last_charged_on, :datetime
  end
end
