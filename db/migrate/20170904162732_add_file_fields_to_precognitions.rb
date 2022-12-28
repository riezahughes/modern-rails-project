class AddFileFieldsToPrecognitions < ActiveRecord::Migration
  def up
    add_attachment :precognitions, :templated_document
  end

  def down
    remove_attachment :precognitions, :templated_document
  end
end
