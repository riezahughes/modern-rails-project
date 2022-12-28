class AccountChargeItemsController < AuthoritativeController
  include HideDefaultList
  before_action :set_account_charge_item, only: [:show, :edit, :update, :destroy]
  # GET /account_charge_items
  def index
    @search = AccountChargeItem.ransack(params[:q])
    @account_charge_items = hidden_results(@search).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /account_charge_items/1
  def show
  end

  # GET /account_charge_items/new
  def new
    @account_charge_item = AccountChargeItem.new
  end

  # GET /account_charge_items/1/edit
  def edit
  end

  # POST /account_charge_items
  def create
    @account_charge_item = AccountChargeItem.new(account_charge_item_params)

    if @account_charge_item.save
      redirect_to @account_charge_item, notice: 'Account charge item was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /account_charge_items/1
  def update
    if @account_charge_item.update(account_charge_item_params)
      redirect_to @account_charge_item, notice: 'Account charge item was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /account_charge_items/1
  def destroy
    @account_charge_item.destroy
    redirect_to account_charge_items_url, notice: 'Account charge item was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_account_charge_item
    @account_charge_item = AccountChargeItem.find(params[:id])
  end

  protected
  # Only allow a trusted parameter "white list" through.
  def account_charge_item_params
    params.require(:account_charge_item).permit(:fee_amount, :outlay_amount, :narrative, :account_id, :chargeable_item_id, :chargeable_item_type, :item_charge_rate_id)
  end
end
