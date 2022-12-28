class Calculations::BlockDistanceCalculation

  def self.amount_for_block_distance(charge_rate, distance)

    block_distance = charge_rate.block_distance_miles
    block_charge = charge_rate.block_distance_charge

    raise InvalidChargeRateError.new charge_rate, "Block distance can't be blank" if block_distance.blank?

    self.amount_for_distance(distance, block_charge, block_distance)
  end

  private
  def self.amount_for_distance(distance_in_miles, rate, block_size)
    ((distance_in_miles.to_f/block_size).ceil * rate)
  end

end
