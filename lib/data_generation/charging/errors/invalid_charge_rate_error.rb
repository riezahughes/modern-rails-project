class InvalidChargeRateError < StandardError
  def initialize(charge_rate, message)
    @charge_rate = charge_rate
    @message = message
  end

  def charge_rate
    @charge_rate
  end

  def message
    @message
  end

  def to_s
    @message
  end

end
