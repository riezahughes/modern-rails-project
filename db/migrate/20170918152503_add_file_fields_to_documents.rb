class AddFileFieldsToDocuments < ActiveRecord::Migration
  def up
    add_attachment :documents, :document_file
  end

  def down
    remove_attachment :documents, :document_file
  end
end
