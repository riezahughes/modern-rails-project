class AddClientFileCountToJourneys < ActiveRecord::Migration
  def change
    add_column :journeys, :client_file_count, :integer
  end
end
