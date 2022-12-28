class ChargeableItems::Calculators::CourtAttendanceItem
  include Helpers::DescriptionHelper

  def self.calculate_charge(item, account, charge_rate)

    raise ChargeCalculationError.new 'No Court Attendance item given' unless item

    fee_amount = Calculations::BlockTimeCalculation.amount_for_block_duration charge_rate, (item.duration.to_f/60)

    AccountChargeItem.create!(fee_amount: fee_amount,
     narrative: item.narrative,
     account: account,
     chargeable_item: item,
     item_charge_rate: charge_rate,
     item_date: item.start_date)
  end

  def self.charge_rate_description(item)
    "Attendance charge for #{Helpers::DescriptionHelper.formatted_duration(item)}"\
    " at £#{item.item_charge_rate.initial_block_charge} for the first #{item.item_charge_rate.initial_block_duration_mins} mins"\
    " and £#{item.item_charge_rate.block_charge} per #{item.item_charge_rate.block_duration_mins} mins"
  end

end
