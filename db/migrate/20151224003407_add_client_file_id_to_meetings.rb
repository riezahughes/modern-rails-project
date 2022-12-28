class AddClientFileIdToMeetings < ActiveRecord::Migration[4.2]
  def change
    add_column :meetings, :client_file_id, :integer
  end
end
