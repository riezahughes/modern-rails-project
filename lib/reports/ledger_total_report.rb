module Reports::LedgerTotalReport

  def client_ledger_totals(client)
    totals_record = client.ledgers
                        .select('sum(ledgers.amount_in_pennies) as total_in,
	                               sum(ledgers.amount_out_pennies) as total_out').first
    return Reports::LedgerTotal.new(totals_record.total_in, totals_record.total_out) unless totals_record.nil?
    Reports::LedgerTotal.new(0, 0)
  end

  class Reports::LedgerTotal

    attr_reader :total_in, :total_out

    def initialize(total_in, total_out)
      @total_in = Money.new(total_in)
      @total_out = Money.new(total_out)
    end

  end

end