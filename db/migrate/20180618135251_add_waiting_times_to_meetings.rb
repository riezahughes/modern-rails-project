class AddWaitingTimesToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :waiting_time_start, :datetime
    add_column :meetings, :waiting_time_end, :datetime
  end
end
