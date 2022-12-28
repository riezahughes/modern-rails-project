class AccountsController < AuthoritativeController
  include HideDefaultList
  include ChargingControllerHelper
  include ClientFileChildControllerHelper

  before_action :set_account, only: [:show, :edit, :update, :destroy, :charge, :expenses_report]

  autocomplete :client_file, :file_number

  # GET /accounts
  def index
    @search = Account.ransack(params[:q])
    @search.sorts = 'last_charged_on desc' if @search.sorts.empty?
    @accounts = @search.result(distinct: true)
      .includes(:client_file, :account_type)
      .paginate(:per_page => 10, :page => params[:page])
  end

  # GET /accounts/1
  def show
    @claims = @account.claims.order(claim_date: :desc).paginate(:per_page => 10, :page => params[:claims_page])
    @account_increases = @account.account_increases.order(date_granted: :desc).paginate(:per_page => 10, :page => params[:account_increases_page])
    @account_charge_items = @account.account_charge_items.order(item_date: :desc).paginate(:per_page => 10, :page => params[:account_charge_items_page])
    @claim = Claim.new
    @account_increase = AccountIncrease.new
  end

  # GET /accounts/1/expenses_report
  def expenses_report
    @account_charge_items = @account.account_charge_items.order(item_date: :asc)
    @fee_total = @account.expense_report_fee_total
    @outlay_total = @account.expense_report_outlay_total
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  def create
    @account = Account.new(account_params)

    if @account.save
      redirect_to @account, notice: 'Account was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /accounts/1
  def update
    if @account.update(account_params)
      redirect_to @account, notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /accounts/1
  def destroy
    @account.destroy
    redirect_to @account.client_file, notice: 'Account was successfully destroyed.'
  end

  # POST /accounts/1/charge
  def charge
    begin
      AccountCharge.charge! @account
      redirect_to @account, notice: 'Account was successfully charged.'
    rescue ChargeCalculationError => error
      handle_calculation_error error, @account, "Could not charge account: #{error}"
    rescue MissingChargeRateError => error
      handle_missing_charge_rate_error error, @account
    rescue InvalidChargeRateError => error
      handle_invalid_charge_rate_error error, @account
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = Account.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def account_params

    params.require(:account).permit(:effective_from,
                                    :effective_until,
                                    :feed_upto,
                                    :feed_date,
                                    :feed_status,
                                    :expenditure,
                                    :expenditure_limit,
                                    :reference,
                                    :nominated_solicitor_id,
                                    :client_file_id,
                                    :account_type_id)

  end
end
