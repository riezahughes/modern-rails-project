class AddLengthToPrecognitions < ActiveRecord::Migration
  def change
    add_column :precognitions, :length, :integer
  end
end
