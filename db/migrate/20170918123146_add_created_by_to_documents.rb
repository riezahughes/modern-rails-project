class AddCreatedByToDocuments < ActiveRecord::Migration
  def change
    add_reference :documents, :created_by, index: true
    add_foreign_key :documents, :users, column: :created_by_id
  end
end
