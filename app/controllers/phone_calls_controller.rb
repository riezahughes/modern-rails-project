class PhoneCallsController < AuthoritativeController
  include HideDefaultList
  include WorkControllerHelper
  include NotifiableActions
  include ChargeableItemTriggers
  include ClientFileChildControllerHelper
  helper ClientsHelper

  before_action :set_phone_call, only: [:show, :edit, :update, :destroy, :sheet]

  autocomplete :client_file, :file_number
  autocomplete :phone_call, :attendance_with, scopes: [:uniquely_attendance_with]

  # GET /phone_calls
  def index
    @search = PhoneCall.ransack(params[:q])
    @phone_calls = hidden_results(@search).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /phone_calls/1
  def show
  end

  # GET /phone_calls/1/sheet
  def sheet
  end

  # GET /phone_calls/new
  def new
    @client = Client.new
    @client_file = @client_file || ClientFile.new
    @phone_call = PhoneCall.new
  end

  # GET /phone_calls/1/edit
  def edit
  end

  # POST /phone_calls
  def create
    @phone_call = PhoneCall.new(phone_call_params)
    @phone_call.created_by = current_user
    add_new_work @phone_call
    @chargeable_item = @phone_call

    if @phone_call.save
      redirect_to @phone_call, notice: 'Phone call was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /phone_calls/1
  def update

    update_work @phone_call
    if @phone_call.update(phone_call_params)
      redirect_to @phone_call, notice: 'Phone call was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /phone_calls/1
  def destroy
    @phone_call.destroy
    redirect_to @phone_call.client_file, notice: 'Phone call was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_phone_call
    @phone_call = PhoneCall.find(params[:id])
  end

  def set_notifiable
    @notifiable = PhoneCall.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def phone_call_params
    params.require(:phone_call).permit(:attendance_with, :description, :chargeable, :client_file_id)
  end

end
