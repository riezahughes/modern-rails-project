class AddDocumentTemplateToMeetings < ActiveRecord::Migration
  def change
    add_reference :meetings, :document_template, index: true, foreign_key: true
  end
end
