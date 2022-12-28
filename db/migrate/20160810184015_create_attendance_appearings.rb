class CreateAttendanceAppearings < ActiveRecord::Migration[4.2]
  def change
    create_table :attendance_appearings do |t|
      t.boolean :counsel

      t.timestamps null: false
    end
  end
end
