module Reports::ClientBalanceReport

  def client_balance_records(date)

    end_date = date.end_of_month

    subquery = PersonClient.select('MAX(ledgers.created_at) as max_created_at,
                              MAX(ledgers.date_paid) as max_paid_date,
                              clients.id as client_id,
                              personal_details.surname')
                   .joins(:ledgers)
                   .joins(:personal_details)
                   .where('date_paid <= ?', end_date)
                   .group('client_id').to_sql


    Ledger.joins("JOIN (#{subquery}) AS ledgers_inner ON
        ledgers.created_at = ledgers_inner.max_created_at AND
        ledgers.date_paid = ledgers_inner.max_paid_date AND
        ledgers.client_id = ledgers_inner.client_id")
        .order('surname')
        .select('ledgers.client_id AS client_id, ledgers.balance_pennies AS balance_pennies')
        .where('ledgers.balance_pennies > ?', 0)

  end

end

