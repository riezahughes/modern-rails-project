class AddNationalInsuranceNumberAndEmailAddressToClients < ActiveRecord::Migration[4.2]
  def change
    add_column :clients, :national_insurance_number, :string
    add_column :clients, :email_address, :string
  end
end
