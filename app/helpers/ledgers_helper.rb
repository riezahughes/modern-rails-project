module LedgersHelper

  def get_calculated_balance(ledgerable, amount_in, amount_out)

    balance = 0
    unless ledgerable.ledgers.blank?
      ledgers = ledgerable.ledgers.order(date_paid: :desc, created_at: :desc).all
      balance = ledgers.first.balance.cents
    end

    balance += amount_in
    balance -= amount_out

  end

end
