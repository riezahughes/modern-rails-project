class Calculations::BlockTimeCalculation

  def self.amount_for_block_duration(charge_rate, duration)

    raise ChargeCalculationError.new 'No charge rate given' unless charge_rate

    initial_block_duration = charge_rate.initial_block_duration_mins
    initial_block_charge = charge_rate.initial_block_charge
    block_duration = charge_rate.block_duration_mins
    block_charge = charge_rate.block_charge

    raise InvalidChargeRateError.new charge_rate, 'Initial block duration can\'t be blank' if initial_block_duration.blank?
    raise InvalidChargeRateError.new charge_rate, 'Block duration can\'t be blank' if block_duration.blank?

    amount_for_initial_block = self.amount_for_initial_block(duration, initial_block_charge)
    amount_for_rest_of_blocks = self.amount_for_duration(self.remove_initial_block_duration(duration, initial_block_duration), block_charge, block_duration)
    amount_for_initial_block + amount_for_rest_of_blocks
  end

  private
  def self.amount_for_duration(duration_in_mins, rate, block_size)
    return 0 if block_size <= 0

    ((duration_in_mins.to_f/block_size).ceil * rate)
  end

  def self.remove_initial_block_duration(duration, initial_block_duration)
    [duration - initial_block_duration, 0].max
  end

  def self.amount_for_initial_block(duration, initial_block_charge)
    return initial_block_charge if duration > 0

    0
  end

end
