class ItemChargeRate < ActiveRecord::Base
  belongs_to :account_type
  has_many :account_charge_items, dependent: :destroy

  monetize :fixed_fee_pennies
  monetize :initial_block_charge_pennies
  monetize :block_charge_pennies
  monetize :block_distance_charge_pennies
  monetize :block_word_length_charge_pennies

  validates :initial_block_duration_mins, numericality:  { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :block_duration_mins, numericality:  { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :block_distance_miles, numericality:  { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :block_word_length, numericality:  { greater_than_or_equal_to: 0 }, allow_nil: true

  validates_presence_of :account_type
  validates_presence_of :chargeable_item_name
  validates_inclusion_of :chargeable_item_name, in: AccountChargeable.classes.map(&:name)
  validates_presence_of :qualification_type
  validates_inclusion_of :qualification_type, in: AccountChargeable.qualification_types
  validates_uniqueness_of :chargeable_item_name, scope: [:qualification_type, :account_type], message: 'with qualification type and account type combination already exists'

  def to_s
    "Charge rate: #{account_type} #{chargeable_item_name} #{qualification_type}"
  end

end
