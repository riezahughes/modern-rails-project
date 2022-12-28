class AddUserIdToMeetings < ActiveRecord::Migration[4.2]
  def change
    add_column :meetings, :user_id, :integer
  end
end
