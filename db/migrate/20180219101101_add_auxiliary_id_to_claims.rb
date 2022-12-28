class AddAuxiliaryIdToClaims < ActiveRecord::Migration
  def change
    add_column :claims, :auxiliary_id, :integer
    add_index :claims, :auxiliary_id
  end
end
