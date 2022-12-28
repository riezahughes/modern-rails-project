class AddTravelMethodReferenceToTravels < ActiveRecord::Migration[4.2]
  def change
    add_reference :travels, :travel_method, index: true, foreign_key: true
  end
end
