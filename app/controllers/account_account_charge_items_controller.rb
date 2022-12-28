class AccountAccountChargeItemsController < AccountChargeItemsController
  skip_authorize_resource
  authorize_resource :account_charge_item, parent: false
  include ChargingControllerHelper

  # GET accounts/x/account_charge_items
  def index
    @account_id = params[:account_id]
    @account = Account.find params[:account_id]
    @search = AccountChargeItem.ransack(params[:q])
    @search.sorts = 'item_date asc' if @search.sorts.empty?
    @account_charge_items = @search.result(distinct: true)
      .includes(:chargeable_item, :item_charge_rate)
      .where(account_id: @account_id)
      .paginate(per_page: 10, page: params[:page])
    @account_charge_item = AccountChargeItem.new
    @total_charge_fee = @account.charge_item_fee_total
    @total_charge_outlay = @account.charge_item_outlay_total
    @sibling_accounts = Account.where(client_file: @account.client_file)
  end

  # GET accounts/x/account_charge_items/new
  def new
    @account_charge_item = AccountChargeItem.new
  end

  # POST accounts/x/account_charge_items
  def create
    @account_charge_item = AccountChargeItem.new(account_charge_item_params)

    respond_to do |format|
      if @account_charge_item.save
        format.html { redirect_to @account_charge_item, notice: 'Account charge item was successfully created.' }
        format.js { render :show, status: :created }
      else
        format.html { render :new }
        format.js { render json: @account_charge_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST accounts/x/account_charge_items/charge
  def charge
    new_account = Account.find(recharge_params[:account_id])
    charge_item_ids = recharge_params[:charge_item_ids]
    items = charge_item_ids.map { |id| AccountChargeItem.find(id).chargeable_item }
    begin
      ChargeableItems::ItemCharge.charge_items_under_account items, new_account, @account
      redirect_to account_account_charge_items_url, notice: "#{charge_item_ids.count} Items were successfully charged."
    rescue ChargeCalculationError => error
      handle_calculation_error error, account_account_charge_items_url(Account.find(params[:account_id])), "Could not charge items: #{error}"
    rescue MissingChargeRateError => error
      handle_missing_charge_rate_error error, account_account_charge_items_url(Account.find(params[:account_id]))
    rescue InvalidChargeRateError => error
      handle_invalid_charge_rate_error error, account_account_charge_items_url(Account.find(params[:account_id]))
    end
  end

  # PATCH/PUT accounts/x/account_charge_items/1
  def update
    respond_to do |format|
      if @account_charge_item.update(account_charge_item_params)
        format.html { redirect_to @account_charge_item, notice: 'Charge item was successfully updated.' }
        format.json { respond_with_bip(@account_charge_item) }
      else
        format.html { render :edit }
        format.json { respond_with_bip(@account_charge_item) }
      end
    end
  end

  # DELETE accounts/x/account_charge_items/1
  def destroy
    @account_charge_item.destroy
    redirect_to account_account_charge_items_url, notice: 'Account charge item was successfully destroyed.'
  end

  # DELETE accounts/x/account_charge_items
  def destroy_all
    Account.find(params[:account_id]).account_charge_items.destroy_all
    redirect_to account_account_charge_items_url, notice: 'Account charge items were successfully destroyed.'
  end

  def recharge_params
    params.require(:recharge).permit(:account_id, charge_item_ids: [])
  end


end
