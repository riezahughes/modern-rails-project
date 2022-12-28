class CreateUserNotification < ActiveRecord::Migration[4.2]
  def change
    create_table :users_notifications, id: false do |t|
      t.references :user
      t.references :notification
    end

    add_index :users_notifications, [:notification_id, :user_id], unique: true
    add_index :users_notifications, :user_id
  end
end
