class ChargeableItems::Calculators::TravelItem
  include Helpers::DescriptionHelper

  def self.calculate_charge(item, account, charge_rate)

    raise ChargeCalculationError.new 'No Travel item given' unless item

    number_of_client_files = [item.client_file_count, 1].max
    fee_amount = Calculations::BlockTimeCalculation.amount_for_block_duration charge_rate, (item.duration.to_f/60)
    outlay_amount = Calculations::BlockDistanceCalculation.amount_for_block_distance charge_rate, item.mileage
    outlay_amount += (item.parking_costs + item.toll_costs + item.other_costs)

    AccountChargeItem.create!(fee_amount: fee_amount/number_of_client_files,
     outlay_amount: outlay_amount/number_of_client_files,
     narrative: item.narrative,
     account: account,
     chargeable_item: item,
     item_charge_rate: charge_rate,
     item_date: item.start_date)
  end

  def self.charge_rate_description(item)
    mileage = item.chargeable_item.mileage.blank? ? 'unknown' : item.chargeable_item.mileage
    "Travel charge for #{Helpers::DescriptionHelper.formatted_duration(item)}"\
    " at £#{item.item_charge_rate.block_charge} per #{item.item_charge_rate.block_duration_mins} mins fee"\
    " and for #{mileage} miles at £#{item.item_charge_rate.block_distance_charge} per #{item.item_charge_rate.block_distance_miles} mile(s) outlay,"\
    " parking costs £#{item.chargeable_item.parking_costs},"\
    " and toll costs £#{item.chargeable_item.toll_costs},"\
    " and other costs £#{item.chargeable_item.other_costs}"\
    " divided between #{item.chargeable_item.client_file_count} files"\
  end

end
