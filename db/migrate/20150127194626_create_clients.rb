class CreateClients < ActiveRecord::Migration[4.2]
  def change
    create_table :clients do |t|
      t.string :type
      t.string :company_name
      t.boolean :local_agent, default: false
      t.date :birth_date
      t.text :address
      t.string :postcode
      t.string :mobile_telephone
      t.string :home_telephone
      t.string :contact_telephone
      t.string :legal_aid_id
      t.string :prison_number
      t.integer :auxiliary_id
      t.index :auxiliary_id
      t.text :additional_contact_information

      t.integer :personal_details_id

      t.timestamps
    end
  end
end
