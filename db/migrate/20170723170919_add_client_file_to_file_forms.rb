class AddClientFileToFileForms < ActiveRecord::Migration
  def change
    add_reference :file_forms, :client_file, index: true, foreign_key: true
  end
end
