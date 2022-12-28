class ClaimsController < AuthoritativeController
  include HideDefaultList
  before_action :set_claim, only: [:show, :edit, :update, :destroy]

  def autocomplete_account_identifier
    accounts = Account.account_search_scope(params[:term]).limit(10)
    render json: accounts.map { |account| {id: account.id,
                                           label: account.to_s,
                                           value: account.to_s} }
  end

  # GET /claims
  def index
    @search = Claim.ransack(params[:q])
    @search.sorts = 'claim_date desc' if @search.sorts.empty?
    @claims = @search.result(distinct: true)
    .joins('LEFT JOIN payments ON payments.claim_id = claims.id')
    .paginate(:per_page => 10, :page => params[:page])

    @total_amount = Money.new(@claims.sum(:amount_pennies))
    @total_paid = Money.new(@claims.sum('payments.fee_amount_pennies + payments.outlay_amount_pennies'))
    @total_outstanding = @total_amount - @total_paid
  end

  # GET /claims/1
  def show
    @payments = @claim.payments.order(payment_date: :desc).paginate(:per_page => 10, :page => params[:payments_page])
    @payment = Payment.new
  end

  def work_in_progress_report

    @search = Claim.ransack(params[:q])
    @search.sorts = ['claim_date desc'] if @search.sorts.empty?
    @claims = @search.result(distinct: true).paginate(:per_page => params[:per_page] || 10, :page => params[:page])

  end

  # GET /claims/new
  def new
    @claim = Claim.new
  end

  # GET /claims/1/edit
  def edit
  end

  # POST /claims
  def create
    @claim = Claim.new(claim_params)

    respond_to do |format|
      if @claim.save
        format.html { redirect_to @claim, notice: 'Claim was successfully created.' }
        format.js { render :show, status: :created }
      else
        format.html { render :new }
        format.js { render json: @claim.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /claims/1
  def update
    if @claim.update(claim_params)
      redirect_to @claim, notice: 'Claim was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /claims/1
  def destroy
    @claim.destroy
    redirect_to claims_url, notice: 'Claim was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_claim
    @claim = Claim.find(params[:id])
    @account = @claim.account
  end

  # Only allow a trusted parameter "white list" through.
  def claim_params
    params.require(:claim).permit(:claim_date, :amount, :accepted, :problem, :notes, :slab_registration_number, :account_id)
  end
end
