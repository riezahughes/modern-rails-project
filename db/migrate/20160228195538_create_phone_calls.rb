class CreatePhoneCalls < ActiveRecord::Migration[4.2]
  def change
    create_table :phone_calls, :options => 'COLLATE=utf8_general_ci' do |t|
      t.string :attendance_with
      t.text :description
      t.boolean :chargeable
      t.references :client_file, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
