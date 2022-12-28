class PaymentsController < AuthoritativeController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]
  # GET /payments
  def index
    @search = Payment.ransack(params[:q])
    @search.sorts = 'payment_date desc' if @search.sorts.empty?
    @payments = @search.result(distinct: true).paginate(per_page: 10, page: params[:page])

    @total_fee_amount = Money.new(@payments.sum(:fee_amount_pennies))
    @total_outlay_amount = Money.new(@payments.sum(:outlay_amount_pennies))
    @total_amount = @total_fee_amount + @total_outlay_amount
  end

  # GET /payments/1
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments
  def create
    @payment = Payment.new(payment_params)

    respond_to do |format|
      if @payment.save
        format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
        format.js { render :show, status: :created }
      else
        format.html { render :new }
        format.js { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /payments/breakdown
  def breakdown

    @search = Payment.ransack(params[:q])
    @payments = @search.result(distinct: true)

    @client_file_type_payment_sums = @payments
    .joins(:client_file).group(:client_file_type_id)
    .sum('fee_amount_pennies + outlay_amount_pennies')
    .map{|k,v| {ClientFileType.find(k).name => v}}.reduce(:merge)

    respond_to do |format|
      format.json {
        render :json => @client_file_type_payment_sums.to_json
      }
    end
  end

  # POST /payments/import
  def import
    data = import_payment_params
    if data[:slab_file]
      payments, missing_registration_numbers = DataImport::SlabData::PaymentImport.payments_from_xml(data[:slab_file].read)
      payments.map(&:save)

      flash[:missing_registration_numbers] = missing_registration_numbers
      redirect_to payments_path, notice: "Imported #{payments.count} payment(s). #{missing_registration_numbers.count} registration number(s) not found."
    else
      redirect_to payments_path, alert: "Please upload a Slab Payments File."
    end
  end

  # PATCH/PUT /payments/1
  def update
    if @payment.update(payment_params)
      redirect_to @payment, notice: 'Payment was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /payments/1
  def destroy
    @payment.destroy
    redirect_to payments_url, notice: 'Payment was successfully destroyed.'
    end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_payment
    @payment = Payment.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def payment_params
    params.require(:payment).permit(:payment_date, :fee_amount, :outlay_amount, :claim_id)
  end

  def import_payment_params
    params.permit(:slab_file)
  end
end
