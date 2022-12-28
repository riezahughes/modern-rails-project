class MissingChargeRateError < StandardError
  def initialize(chargeable_item, account_type, qualification_type)
    @chargeable_item = chargeable_item
    @account_type = account_type
    @qualification_type = qualification_type
  end

  def chargeable_item
    @chargeable_item
  end

  def account_type
    @account_type
  end

  def qualification_type
    @qualification_type
  end

  def creation_attributes
    {
      chargeable_item_name: @chargeable_item.class.name,
      account_type_id: @account_type.id,
      qualification_type: @qualification_type
    }
  end

  def to_s
    "Missing charge rate for #{@qualification_type} #{@account_type} #{@chargeable_item}"
  end

end
