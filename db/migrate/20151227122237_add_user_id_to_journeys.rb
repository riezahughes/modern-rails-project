class AddUserIdToJourneys < ActiveRecord::Migration[4.2]
  def change
    add_column :journeys, :user_id, :integer
  end
end
