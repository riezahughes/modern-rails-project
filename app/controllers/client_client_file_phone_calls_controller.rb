class ClientClientFilePhoneCallsController < AuthoritativeController
  skip_authorize_resource
  authorize_resource :phone_call, parent: false
  respond_to :html
  helper ClientsHelper
  helper PhoneCallsHelper
  include WorkControllerHelper
  include NotifiableActions
  include ChargeableItemTriggers

  # POST /clients/client_files/phone_calls
  def create
    @client = PersonClient.new
    @client_file = ClientFile.new
    @phone_call = PhoneCall.new(new_phone_call_params)

    if existing_client_selected?
      if params[:existing_client_id].blank?
        flash[:alert] = 'Must select a client'
        render 'phone_calls/new' and return
      else
        @client = Client.find(params[:existing_client_id])
      end
    else
      @client = view_context.get_client_from_params params[:client_type], new_client_params, personal_details_params
      @client.created_by = current_user

      unless @client.save
        render 'phone_calls/new' and return
      end
    end

    if existing_client_file_selected?
      if params[:existing_client_file_id].blank?
        flash[:alert] = 'Must select a client file'
        render 'phone_calls/new' and return
      else
        @client_file = ClientFile.find(params[:existing_client_file_id])
      end
    else
      @client_file = ClientFile.new(new_client_file_params)
      @client_file.created_by = current_user
      @client_file.client = @client

      unless @client_file.save
        render 'phone_calls/new' and return
      end
    end

    @phone_call.client_file = @client_file
    @phone_call.created_by = current_user
    add_new_work @phone_call

    if @phone_call.save
      @chargeable_item = @phone_call
      redirect_to @phone_call, notice: 'Phone call was successfully created.'
    else
      render 'phone_calls/new'
    end
  end

  private
  def existing_client_selected?
    params[:existing_new_client_select] == 'existing_client'
  end

  def existing_client_file_selected?
    params[:existing_new_client_file_select] == 'existing_client_file'
  end

  def new_client_params
    params.require(:new_client).permit(:client_type,
                                   :company_name,
                                   :birth_date,
                                   :address,
                                   :postcode,
                                   :mobile_telephone,
                                   :home_telephone,
                                   :contact_telephone,
                                   :additional_contact_information,
                                   :email_address)

  end

  def personal_details_params
    params.require(:personal_details).permit(:title, :forename, :middlenames, :surname, :initials)
  end

  def new_client_file_params
    params.require(:new_client_file)
        .permit(:file_number,
                :subject_matter,
                :client_file_information_id,
                :client_file_type_id)

  end

  def new_phone_call_params
    params.require(:phone_call).permit(:attendance_with, :description, :chargeable)
  end
end
