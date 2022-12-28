class CreatePoliceAuthorities < ActiveRecord::Migration[4.2]
  def change
    create_table :police_authorities do |t|
      t.string :name
      t.text :address
      t.string :city
      t.string :police_constable
      t.string :telephone

      t.timestamps
    end

    add_column :courts, :police_authority_id, :integer
  end
end
