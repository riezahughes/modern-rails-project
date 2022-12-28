class AddLengthToFileForms < ActiveRecord::Migration
  def change
    add_column :file_forms, :length, :integer
  end
end
