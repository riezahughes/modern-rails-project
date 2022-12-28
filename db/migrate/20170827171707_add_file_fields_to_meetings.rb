class AddFileFieldsToMeetings < ActiveRecord::Migration
  def up
    add_attachment :meetings, :templated_document
  end

  def down
    remove_attachment :meetings, :templated_document
  end
end
