class AddPersonalDetailsForeignKeyToClients < ActiveRecord::Migration[4.2]
  def change
    add_foreign_key :clients, :personal_details, column: :personal_details_id
  end
end
