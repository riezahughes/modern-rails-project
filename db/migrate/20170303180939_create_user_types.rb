class CreateUserTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :user_types do |t|
      t.string :name
      t.boolean :qualified_solicitor

      t.timestamps null: false
    end
    add_index :user_types, :name
  end
end
