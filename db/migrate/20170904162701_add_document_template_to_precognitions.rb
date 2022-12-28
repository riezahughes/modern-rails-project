class AddDocumentTemplateToPrecognitions < ActiveRecord::Migration
  def change
    add_reference :precognitions, :document_template, index: true, foreign_key: true
  end
end
