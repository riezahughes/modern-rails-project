class AddWitnessToMeetings < ActiveRecord::Migration
  def change
    add_reference :meetings, :witness, index: true, foreign_key: true
  end
end
