module ClaimsHelper

  def self.account_remainig_amount(claim, account)

    return claim.amount if claim.persisted?
    return account.remaining_amount_to_claim if account

    Money.new(0)
  end

  def outstanding_amount(claim, payments)
    payments.inject(claim.amount) {|outstanding, payment| outstanding - payment.fee_amount - payment.outlay_amount}
  end

end
