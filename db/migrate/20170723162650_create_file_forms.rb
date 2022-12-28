class CreateFileForms < ActiveRecord::Migration[4.2]
  def change
    create_table :file_forms do |t|
      t.datetime :form_date
      t.text :description
      t.boolean :chargeable
      t.references :created_by, index: true

      t.timestamps null: false
    end

    add_foreign_key :file_forms, :users, column: :created_by_id
  end
end
