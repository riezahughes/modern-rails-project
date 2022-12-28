class AddFileFieldsToFileForms < ActiveRecord::Migration
  def up
    add_attachment :file_forms, :templated_document
  end

  def down
    remove_attachment :file_forms, :templated_document
  end
end
