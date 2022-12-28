class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string  :username
      t.integer :id_number
      t.integer :access_code

      t.integer :personal_details_id

      t.timestamps
    end
  end
end
