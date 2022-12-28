class ClientFilesController < AuthoritativeController
  include HideDefaultList
  include DocumentStoreFolderActions
  include DisclosureUploadActions
  include MainFileUploadActions

  before_action :set_client_file, only: [:show, :edit, :update, :destroy, :meetings, :court_dates, :change_witness_cited, :upload_main_file_document, :reopen]
  before_action :set_witness, only: [:change_witness_cited]
  before_action :set_client, only: [:new, :edit, :create, :update]

  # GET /client_files
  def index
    @search = ClientFile.ransack(params[:q])
    @client_files = hidden_results(@search) do |search|
      search
        .joins(:client)
        .includes(:accounts)
        .includes(:client)
        .order(file_status: :asc, date_open: :desc)
    end.paginate(per_page: 10, page: params[:page])
  end

  def autocomplete_client_name
    clients = Client.client_name_scope(params[:term]).limit(10)
    render json: clients.map { |client|
                   { id: client.id,
                     label: "#{client.full_name} (#{client.formatted_birth_date})",
                     value: client.full_name } }
  end

  # GET /client_files/search
  def search
    @search = ClientFile.ransack(params[:q])
  end

  # GET /client_files/1
  def show
    @accounts = @client_file.accounts.order(created_at: :desc).paginate(per_page: 10, page: params[:accounts_page])
    @letters = @client_file.letters.order(letter_date: :desc).paginate(per_page: 10, page: params[:letters_page])
    @meetings = @client_file.meetings.order(created_at: :desc).paginate(per_page: 10, page: params[:meetings_page])
    @phone_calls = @client_file.phone_calls.order(created_at: :desc).paginate(per_page: 10, page: params[:phone_calls_page])
    @court_dates = @client_file.court_dates.order(court_date: :desc).paginate(per_page: 10, page: params[:court_dates_page])
    @witnesses = @client_file.witnesses.order(created_at: :desc).paginate(per_page: 10, page: params[:witnesses_page])
    @file_forms = @client_file.file_forms.order(form_date: :desc).paginate(per_page: 10, page: params[:file_forms_page])
    @debit_entries = @client_file.debit_entries.order(debit_entry_date: :desc).paginate(per_page: 10, page: params[:debit_entries_page])
    @documents = @client_file.documents.order(created_at: :desc).paginate(per_page: 10, page: params[:documents_page])
  end

  # GET /client_files/new
  def new
    @client_file = ClientFile.new
  end

  # GET /client_files/1/edit
  def edit; end

  # POST /client_files
  def create
    @client_file = ClientFile.new(client_file_params)

    if @client_file.save
      redirect_to @client_file, notice: 'Client file was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /client_files/1
  def update
    if @client_file.update(client_file_params)
      redirect_to @client_file, notice: 'Client file was successfully updated.'
    else
      render :edit
    end
  end

  # PATCH/PUT /client_files/1/reopen
  def reopen
    if @client_file.reopen!
      redirect_to @client_file, notice: 'Client file was successfully reopened.'
    else
      render :show
    end
  end

  # GET /client_files/1/meetings
  def meetings
    @meetings = @client_file
                .meetings
                .joins(:work)
                .joins(:meeting_type)
                .order('works.start_date desc')
                .select('meetings.id', 'works.start_date', 'meeting_types.name', 'meetings.attendance_with', 'meetings.description')
                .map do |meeting|
        {
          id: meeting[:id],
          attendance_with: meeting[:attendance_with],
          type: meeting[:name],
          date: meeting[:start_date].to_date.to_s,
          description: view_context.truncate(meeting[:description], length: 40)
        }
      end

    respond_to do |format|
       format.js { render json: @meetings, status: :ok }
    end
  end

  # GET /client_files/1/court_dates
  def court_dates
    @court_dates = @client_file
                   .court_dates
                   .joins(:court)
                   .joins(:court_date_type)
                   .order('court_dates.court_date desc')
                   .select('court_dates.id', 'court_dates.court_date', 'court_date_types.name AS type', 'courts.name AS court')
                   .map do |court_date|
        {
          id: court_date[:id],
          court: court_date[:court].to_s,
          type: court_date[:type].to_s,
          date: court_date[:court_date].to_date.to_s
        }
      end

    respond_to do |format|
       format.js { render json: @court_dates, status: :ok }
    end
  end

  # GET /client_files/get_next_file_number
  def get_next_file_number
    if next_file_number_params[:client_file_type_id]
      type = ClientFileType.find_by_id(next_file_number_params[:client_file_type_id])
      if type
        generator = AutocaseFileNumberGenerator.new
        file_number = generator.next_file_number type

        render plain: file_number

      else
        render plain: 'Invalid type', status: :bad_request
      end

    else
      render plain: 'Invalid type', status: :bad_request
    end
  end

  # GET /client_files/1/witnesses
  def witnesses
    respond_to do |format|
      format.json { @client_file.witnesses }
    end
  end

  # PUT /client_files/1/witnesses/1/change_witness_cited
  def change_witness_cited
    @witness.update!(witness_cited_params)

    respond_to do |format|
      format.json { respond_with_bip(@witness) }
    end
  end

  def destroy
    @client_file.destroy
    redirect_to client_files_url, notice: 'Client file was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_client_file
    @client_file = ClientFile.find_by_file_number(params[:id])
  end

  def set_witness
    @witness = Witness.find(params[:witness_id])
  end

  def set_folder_owner
    @folder_owner = ClientFile.find_by_file_number(params[:id])
  end

  def set_disclosure_owner
    @disclosure_owner = ClientFile.find_by_file_number(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def client_file_params
    params.require(:client_file)
          .permit(:file_number,
                :subject_matter,
                :locus,
                :date_of_offence,
                :date_open,
                :date_closed,
                :disposal,
                :procurator_fiscal_reference,
                :police_reference,
                :allocated,
                :client_id,
                :court_id,
                :procurator_fiscal_id,
                :current_solicitor_id,
                :partner_id,
                :client_file_information_id,
                :client_file_type_id)
  end

  def next_file_number_params
    params.permit(:client_file_type_id)
  end

  def witness_cited_params
    params.require(:witness).permit(:cited)
  end

  def set_client
    if params[:client_id]
      @client_id = params[:client_id]
      @client = Client.find_by_id(@client_id)
    end
  end
end
