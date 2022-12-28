module Reports::AccountExpenditureReport

  def account_expenditure_records(accountable)

    accountable.accounts
        .joins(:account_type)
        .select('account_types.name,
                SUM(account_types.initial_expenditure_limit_pennies) AS total_initial,
                SUM(accounts.expenditure_limit_pennies) AS total_limit,
                SUM(accounts.expenditure_pennies) AS total_expenditure')
        .group('account_types.id')

  end

  def get_account_warnings(accountable)
    return [] if accountable.accounts.empty?
    account_expenditure_records(accountable)
        .select('(SUM(accounts.expenditure_pennies)/SUM(accounts.expenditure_limit_pennies))*100 as spent_percentage')
        .having('SUM(accounts.expenditure_limit_pennies) > 0 AND SUM(accounts.expenditure_pennies) > 0')
        .collect { |warning_record| Reports::AccountExpenditureWarning.new(warning_record.name,
                                                                           warning_record.total_limit,
                                                                           warning_record.total_expenditure,
                                                                           warning_record.spent_percentage) }

  end

  def account_expenditure_by_type(accountable, account_type)
    Money.new(accountable.accounts
        .joins(:account_type)
        .select('SUM(accounts.expenditure_pennies) AS total_expenditure')
        .where(account_type: account_type).first.total_expenditure)
  end

  class Reports::AccountExpenditureWarning

    def initialize(type_name, total_limit, total_spent, spent_percentage)
      @type_name = type_name
      @total_limit = Money.new(total_limit)
      @total_spent = Money.new(total_spent)
      @spent_percentage = spent_percentage
    end

    def show?
      !@spent_percentage.nil? && @spent_percentage > 50
    end

    def get_warning_class

      return 'label-info' if @spent_percentage.nil?

      return 'label-danger' if @spent_percentage > 80

      return 'label-warning' if @spent_percentage > 50

      'label-info'
    end

    def spent_amount_string
      "#{(@total_spent.format)} out of #{(@total_limit.format)}"
    end

    def to_html
      if @spent_percentage.nil?
        ''
      else
        "<span data-toggle='tooltip' title='#{spent_amount_string}' class='label #{get_warning_class}'>#{@type_name} #{@spent_percentage.round(1)}%</span>"
      end
    end

    def to_s
      to_html
    end
  end

end