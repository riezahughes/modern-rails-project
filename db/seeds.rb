# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#
# Seed groups
#
ADMIN_GROUP_NAME = 'Administrators'

permissions_creator = DataGeneration::PermissionCreator.new
permissions_creator.setup_actions_controllers_db

unless Group.exists?(name: ADMIN_GROUP_NAME)
  admin_group = Group.new(name: ADMIN_GROUP_NAME, description: 'Administrative group with ability to view and edit everything')
  admin_group.permissions << Permission.find_by(action: 'manage', subject_class: 'all')
  admin_group.save!
end

if Rails.env.development?
#
# Seed users
#

  DEV_USERNAME = 'dev'
  dev = User.find_by(username: DEV_USERNAME)
  if dev.nil?
    dev = User.create!(username: DEV_USERNAME, personal_details: PersonalDetails.create(title: 'Mr', forename: 'Dev', surname: 'User', initials: 'DU'), password: '123', password_confirmation: '123')
  end

  dev.groups << Group.find_by(name: ADMIN_GROUP_NAME) unless dev.groups.where(name: ADMIN_GROUP_NAME).exists?

end


#
# Retrospectively add default account charge rates to account types
#
AccountType.where(account_charge_rate: nil).each do |account_type|
  unless account_type.account_charge_rate
    account_type.update!(account_charge_rate: AccountChargeRate.create!(account_type: account_type, fixed_fee: 0))
  end
end

AccountChargeable.classes.map(&:name).each do |chargeable_class|
  AccountChargeable.qualification_types.each do |qualification_type|
    AccountType.pluck(:id).each do |account_type_id|
      ItemChargeRate.where(
      account_type_id: account_type_id,
      qualification_type: qualification_type,
      chargeable_item_name: chargeable_class,
      initial_block_duration_mins: 0,
      block_duration_mins: 0).first_or_create
    end
  end
end

Jurisdiction.create([
  {name: "Glasgow and Strathkelvin"},
  {name: "Grampian, Highland and Islands"},
  {name: "Lothian and Borders"},
  {name: "North Strathclyde"},
  {name: "South Strathclyde, Dumfries and Galloway"},
  {name: "Tayside, Central and Fife"}
])

Group.create([
  {name: "Read only", description: "", permissions: Permission.find_all_by_id([2])},
  {name: "Staff", description: "",
    permissions: Permission.find_all_by_id([3, 9, 15, 21, 27, 33, 39, 49, 55, 68,
      76, 89, 95, 125, 131, 150, 164, 170, 176, 182, 195, 201, 207, 213, 219, 228,
      234, 246, 256, 263, 279, 291, 301, 306, 320, 331, 337, 351, 380, 146, 242,
      138, 139, 140, 141, 142, 143, 278, 115, 116, 117, 118, 120, 121, 122, 123, 124])}
])
