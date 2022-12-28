class AddUserIdToLetters < ActiveRecord::Migration[4.2]
  def change
    add_column :letters, :user_id, :integer
  end
end
