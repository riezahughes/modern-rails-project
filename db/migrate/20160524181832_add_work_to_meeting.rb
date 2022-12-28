class AddWorkToMeeting < ActiveRecord::Migration[4.2]
  def change
    add_reference :meetings, :work, index: true, foreign_key: true
  end
end
