class AddSlabRegistrationNumberToClaims < ActiveRecord::Migration
  def change
    add_column :claims, :slab_registration_number, :string
    add_index :claims, :slab_registration_number
  end
end
