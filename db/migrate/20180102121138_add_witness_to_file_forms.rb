class AddWitnessToFileForms < ActiveRecord::Migration
  def change
    add_reference :file_forms, :witness, index: true, foreign_key: true
  end
end
