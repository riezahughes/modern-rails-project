class AddJurisdictionToCourts < ActiveRecord::Migration
  def change
    add_reference :courts, :jurisdiction, index: true, foreign_key: true
  end
end
