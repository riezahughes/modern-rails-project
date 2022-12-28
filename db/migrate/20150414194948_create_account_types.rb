class CreateAccountTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :account_types do |t|
      t.string :name
      t.money :initial_expenditure_limit

      t.timestamps
    end

    add_index :account_types, :name, unique: true
    add_column :accounts, :account_type_id, :integer
  end
end
