class AddJourneyReferenceToMeetings < ActiveRecord::Migration[4.2]
  def change
    add_reference :meetings, :journey, index: true, foreign_key: true
  end
end
