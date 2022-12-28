class ChargeableItems::Calculators::PrecognitionItem

  def self.calculate_charge(item, account, charge_rate)

    raise ChargeCalculationError.new 'No Precognition item given' unless item
    
    fee_amount = Calculations::BlockWordLengthCalculation.amount_for_block_word_length charge_rate, item.length

    AccountChargeItem.create!(fee_amount: fee_amount,
     narrative: item.narrative,
     account: account,
     chargeable_item: item,
     item_charge_rate: charge_rate,
     item_date: item.date_framed)
  end

  def self.charge_rate_description(item)
    "Precognition charge for #{item.chargeable_item.length}"\
    " at £#{item.item_charge_rate.block_word_length_charge} per #{item.item_charge_rate.block_word_length} words"
  end

end
