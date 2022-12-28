class AddAuxiliaryIdToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :auxiliary_id, :integer
  end
end
