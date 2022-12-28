class ClientsController < AuthoritativeController
  include HideDefaultList
  include DocumentStoreFolderActions
  helper ClientFilesHelper

  before_action :set_client, only: [:show, :edit, :update, :destroy, :client_file_report, :client_files]
  # GET /clients
  def index

    @search = PersonClient.ransack(params[:q])
    @search.sorts = ['surname_sort asc', 'forename_sort asc', 'middlenames_sort asc'] if @search.sorts.empty?
    @clients = hidden_results(@search) do |search|
      search
      .joins('LEFT JOIN personal_details ON personal_details_id = personal_details.id')
      .joins('LEFT JOIN locations ON location_id = locations.id')
      .includes(:location, :personal_details)
    end.paginate(:per_page => 500, :page => params[:page])

  end

  # GET /clients/search
  def search
    @search = Client.ransack(params[:q])
  end

  # GET /clients/1
  def show
    @ledger = Ledger.new
    @client_files = @client.client_files.order(file_status: :asc, date_open: :desc).paginate(:per_page => 10, :page => params[:client_files_page])
    @accounts = @client.accounts.order(effective_from: :desc).paginate(:per_page => 10, :page => params[:accounts_page])
    @ledgers = @client.ledgers.order(date_paid: :desc)
    @documents = @client.documents.order(created_at: :desc).paginate(per_page: 10, page: params[:documents_page])
  end

  # GET /clients/new
  def new
    @client = PersonClient.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  def create

    @client = view_context.get_client_from_params params[:client_type], client_params, personal_details_params
    @client.created_by = current_user

    if @client.save
      redirect_to client_url(@client), notice: 'Client was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /clients/1
  def update

    if view_context.update_client params[:client_type], @client, client_params, personal_details_params
      # if @client.update(client_params)
      redirect_to client_url(@client), notice: 'Client was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /clients/1
  def destroy
    @client.destroy
    redirect_to clients_url, notice: 'Client was successfully destroyed.'
  end

  # GET /clients/1/client_files
  def client_files
    respond_to do |format|
      format.html do
        @search = ClientFile.ransack(params[:q])
        @client_files = @search.result(distinct: true)
            .joins(:client)
            .includes(:accounts)
            .includes(:client)
            .where(client: @client)
            .order(file_status: :asc, date_open: :desc)
            .paginate(:per_page => 10, :page => params[:page])

        render template: 'client_files/index'
      end
      format.js { render json: @client.client_files.order(file_status: :asc, date_open: :desc).select(:id, :file_number, :subject_matter), status: :ok }
    end
  end

  def balance_report
    if balance_report_params.blank?
      @date = Date.today
    else
      date_param = balance_report_params[:date]
      @date = Date.new(date_param[:year].to_i, date_param[:month].to_i, date_param[:day].to_i)
    end
  end

  def client_file_report

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_client
    @client = Client.find(params[:id])
  end

  def set_folder_owner
    @folder_owner = Client.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def client_params

    params.require(:client).permit(:client_type,
                                   :company_name,
                                   :birth_date,
                                   :address,
                                   :postcode,
                                   :mobile_telephone,
                                   :home_telephone,
                                   :contact_telephone,
                                   :legal_aid_id,
                                   :prison_number,
                                   :additional_contact_information,
                                   :email_address,
                                   :national_insurance_number,
                                   :location_id)

  end

  def personal_details_params
    params.require(:personal_details).permit(:title, :forename, :middlenames, :surname, :initials)
  end

  def balance_report_params
    params.permit(date: [:day, :month, :year])
  end


end
