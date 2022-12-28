class CreateMeetingTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :meeting_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
