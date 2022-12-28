class CreateAttendanceWaitings < ActiveRecord::Migration[4.2]
  def change
    create_table :attendance_waitings do |t|
      t.timestamps null: false
    end
  end
end
