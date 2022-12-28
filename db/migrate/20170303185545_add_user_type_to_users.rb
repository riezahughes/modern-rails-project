class AddUserTypeToUsers < ActiveRecord::Migration[4.2]
  def change
    add_reference :users, :user_type, index: true, foreign_key: true
  end
end
