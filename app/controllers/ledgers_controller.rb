class LedgersController < AuthoritativeController
  before_action :set_ledger, only: [:show, :edit, :update, :destroy]
  before_action :set_ledgerable, only: [:get_balance]

  # GET /ledgers
  def index
    @search = Ledger.ransack(params[:q])
    @ledgers = @search.result(distinct: true)
      .joins(:client)
      .joins('LEFT JOIN personal_details ON personal_details_id = personal_details.id')
      .paginate(:per_page => 10, :page => params[:page])
  end

  def autocomplete_client_name
    clients = Client.client_name_scope(params[:term]).limit(10)
    render json: clients.map { |client| {id: client.id,
                                         label: "#{client.full_name} (#{client.formatted_birth_date})",
                                         value: client.full_name} }
  end

  # GET /ledgers/1
  def show
  end

  # GET /ledgers/new
  def new
    @ledger = Ledger.new
  end

  # GET /ledgers/1/edit
  def edit
  end

  # POST /ledgers
  def create
    @ledger = Ledger.new(ledger_params)

    respond_to do |format|
      if @ledger.save
        format.html { redirect_to @ledger, notice: 'Ledger was successfully created.' }
        format.js { render :show, status: :created }
      else
        format.html { render :new }
        format.js { render json: @ledger.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ledgers/1
  def update
    if @ledger.update(ledger_params)
      redirect_to @ledger, notice: 'Ledger was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /ledgers/1
  def destroy
    @ledger.destroy
    redirect_to ledgers_url, notice: 'Ledger was successfully destroyed.'
  end

  # GET /ledgers/get_balance
  def get_balance
    if @ledgerable.nil?
      render plain: 0, status: :bad_request
    else
      begin
        amount_in_pennies = Monetize.parse(ledger_balance_params[:amount_in]).cents
        amount_out_pennies = Monetize.parse(ledger_balance_params[:amount_out]).cents
        balance = view_context.get_calculated_balance @ledgerable, amount_in_pennies, amount_out_pennies
        render plain: balance
      rescue Exception => e
        render plain: e.message, status: :bad_request
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_ledger
    @ledger = Ledger.find(params[:id])
  end

  private
  def set_ledgerable
    @ledgerable = Client.find_by_id(ledger_balance_params[:client_id])
  end

  # Only allow a trusted parameter "white list" through.
  def ledger_balance_params
    params.permit(:amount_in, :amount_out, :client_id)
  end

  def ledger_params
    params.require(:ledger).permit(:date_paid, :narrative, :amount_in, :amount_out, :balance, :client_id)
  end
end
