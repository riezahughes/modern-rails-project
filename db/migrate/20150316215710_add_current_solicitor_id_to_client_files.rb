class AddCurrentSolicitorIdToClientFiles < ActiveRecord::Migration[4.2]
  def change
    add_column :client_files, :current_solicitor_id, :integer
  end
end
