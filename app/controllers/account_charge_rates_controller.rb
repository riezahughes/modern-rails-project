class AccountChargeRatesController < ApplicationController
  before_action :set_account_charge_rate, only: [:show, :edit, :update, :destroy]
  # GET /account_charge_rates
  def index
    @search = AccountChargeRate.ransack(params[:q])
    @account_charge_rates = @search.result(distinct: true).paginate(:per_page => 10, :page => params[:page])
  end
  # GET /account_charge_rates/1
  def show
  end

  # GET /account_charge_rates/new
  def new
    account_type = AccountType.where(params[:account_type_id]).first
    @account_charge_rate = AccountChargeRate.new(account_type: account_type)
  end

  # GET /account_charge_rates/1/edit
  def edit
  end

  # POST /account_charge_rates
  def create
    @account_charge_rate = AccountChargeRate.new(account_charge_rate_params.slice!(:account_type_id))

    account_type = AccountType.where(params[:account_type_id]).first
    @account_charge_rate.account_type = account_type if account_type

    if @account_charge_rate.save
      redirect_to @account_charge_rate, notice: 'Account charge rate was successfully created.'
    else
      render :new
    end
  end
  # PATCH/PUT /account_charge_rates/1
  def update
    respond_to do |format|
      if @account_charge_rate.update(account_charge_rate_params.slice!(:account_type_id))
        format.html { redirect_to @account_charge_rate, notice: 'Account charge rate was successfully updated.' }
        format.json { respond_with_bip(@account_charge_rate) }
      else
        format.html { render :edit }
        format.json { respond_with_bip(@account_charge_rate) }
      end
    end
  end
  # DELETE /account_charge_rates/1
  def destroy
    @account_charge_rate.destroy
    redirect_to account_charge_rates_url, notice: 'Account charge rate was successfully destroyed.'
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account_charge_rate
  @account_charge_rate = AccountChargeRate.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def account_charge_rate_params
      params.require(:account_charge_rate).permit(:fixed_fee, :account_type_id)
    end
end
