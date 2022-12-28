class AddDateFramedToPrecognitions < ActiveRecord::Migration
  def change
    add_column :precognitions, :date_framed, :datetime
  end
end
