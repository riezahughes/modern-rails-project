class RemoveDepartureDateReturnDateFromJourneys < ActiveRecord::Migration[4.2]
  def change
    remove_column :journeys, :departure_date, :datetime
    remove_column :journeys, :return_date, :datetime
  end
end
