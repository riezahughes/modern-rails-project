class Calculations::BlockWordLengthCalculation

  def self.amount_for_block_word_length(charge_rate, word_length)

    block_word_length = charge_rate.block_word_length
    block_charge = charge_rate.block_word_length_charge

    raise InvalidChargeRateError.new charge_rate, "Block word length can't be blank" if block_word_length.blank?

    self.amount_for_word_length(word_length, block_charge, block_word_length)
  end

  private
  def self.amount_for_word_length(word_length, rate, block_size)
    ((word_length.to_f/block_size).ceil * rate)
  end

end
