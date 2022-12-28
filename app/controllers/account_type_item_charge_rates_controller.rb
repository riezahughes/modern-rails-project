class AccountTypeItemChargeRatesController < ItemChargeRatesController
  skip_authorize_resource
  authorize_resource :item_charge_rate, parent: false

  # GET account_types/x/item_charge_rates
  def index
    @account_type_id = params[:account_type_id]
    @account_type = AccountType.find params[:account_type_id]
    @search = ItemChargeRate.ransack(params[:q])
    @item_charge_rates = @search.result(distinct: true).where(account_type_id: @account_type_id).paginate(per_page: 10, page: params[:page])
  end

  # PATCH/PUT accounts/x/charge_items/1
  def update
    respond_to do |format|
      if @item_charge_rate.update(item_charge_rate_params)
        format.html { redirect_to @item_charge_rate, notice: 'Account Charge Rate was successfully updated.' }
        format.json { respond_with_bip(@item_charge_rate) }
      else
        format.html { render :edit }
        format.json { respond_with_bip(@item_charge_rate) }
      end
    end
  end

end
