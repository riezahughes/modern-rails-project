class AccountIncreasesController < AuthoritativeController
  before_action :set_account_increase, only: %i[show edit update destroy]
  # GET /account_increases
  def index
    @search = AccountIncrease.ransack(params[:q])
    @account_increases = @search.result(distinct: true).paginate(per_page: 10, page: params[:page])
  end

  # GET /account_increases/1
  def show; end

  # GET /account_increases/new
  def new
    @account_increase = AccountIncrease.new
  end

  # GET /account_increases/1/edit
  def edit; end

  # POST /account_increases
  def create
    @account_increase = AccountIncrease.new(account_increase_params)

    respond_to do |format|
      if @account_increase.save
        format.html { redirect_to @account_increase, notice: 'Account increase was successfully created.' }
        format.js { render :show, status: :created }
      else
        format.html { render :new }
        format.js { render json: @account_increase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account_increases/1
  def update
    if @account_increase.update(account_increase_params)
      redirect_to @account_increase, notice: 'Account increase was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /account_increases/1
  def destroy
    @account_increase.destroy
    redirect_to account_increases_url, notice: 'Account increase was successfully destroyed.'
    end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account_increase
    @account_increase = AccountIncrease.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def account_increase_params
    params.require(:account_increase).permit(:amount, :date_granted, :granted_by, :account_id)
end
end
