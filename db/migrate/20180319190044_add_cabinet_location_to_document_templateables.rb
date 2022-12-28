class AddCabinetLocationToDocumentTemplateables < ActiveRecord::Migration

  DOCUMENT_TEMPLATEABLES = [:file_forms, :letters, :precognitions]

  def up
    DOCUMENT_TEMPLATEABLES.each { |document_templateable| add_column document_templateable, :cabinet_location, :string }

  end

  def down
    DOCUMENT_TEMPLATEABLES.each { |document_templateable| remove_column document_templateable, :cabinet_location, :string }
  end

end
