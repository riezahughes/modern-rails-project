class CreateNotifications < ActiveRecord::Migration[4.2]
  def change
    create_table :notifications do |t|
      t.string :entity

      t.timestamps null: false
    end
    add_index :notifications, :entity, unique: true
  end
end
