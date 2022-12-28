class AccountTypesController < AuthoritativeController
  before_action :set_account_type, only: [:show, :edit, :update, :destroy]
  # GET /account_types
  def index
    @search = AccountType.ransack(params[:q])
    @account_types = @search.result(distinct: true).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /account_types/1
  def show
    @item_charge_rates = @account_type.item_charge_rates.paginate(:per_page => 10, :page => params[:item_charge_rates_page])
  end

  # GET /account_types/new
  def new
    @account_type = AccountType.new
  end

  # GET /account_types/1/edit
  def edit
  end

  # POST /account_types
  def create
    @account_type = AccountType.new(account_type_params)

    if @account_type.save
      redirect_to @account_type, notice: 'Account type was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /account_types/1
  def update
    if @account_type.update(account_type_params)
      redirect_to @account_type, notice: 'Account type was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /account_types/1
  def destroy
    @account_type.destroy
    redirect_to account_types_url, notice: 'Account type was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_account_type
    @account_type = AccountType.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def account_type_params

    params.require(:account_type).permit(:name, :initial_expenditure_limit, :account_charge_rate_id, :account_charge_type)

  end
end
