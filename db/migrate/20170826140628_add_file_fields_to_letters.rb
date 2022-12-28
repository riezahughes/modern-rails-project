class AddFileFieldsToLetters < ActiveRecord::Migration
  def up
    add_attachment :letters, :templated_document
  end

  def down
    remove_attachment :letters, :templated_document
  end
end
