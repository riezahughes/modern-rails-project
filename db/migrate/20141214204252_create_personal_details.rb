class CreatePersonalDetails < ActiveRecord::Migration[4.2]
  def change
    create_table :personal_details do |t|
      t.string :title
      t.string :forename
      t.string :middlenames
      t.string :surname
      t.string :initials

      # t.integer :personable_id, null: true
      # t.string :personable_type, null: true

      t.timestamps
    end
  end
end
