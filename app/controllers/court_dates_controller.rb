class CourtDatesController < AuthoritativeController
  include HideDefaultList
  include ClientFileChildControllerHelper
  before_action :set_court_date, only: [:show, :edit, :update, :destroy]

  autocomplete :client_file, :file_number

  def autocomplete_journey_identifier
    journeys = Journey.journey_search_scope(params[:term]).limit(10)
    render json: journeys.map { |journey| {id: journey.id,
                                           label: journey.formatted_identifier,
                                           value: journey.formatted_identifier} }
  end

  # GET /court_dates
  def index
    @search = CourtDate.ransack(params[:q])
    @search.sorts = ['court_date desc'] if @search.sorts.empty?
    @court_dates = @search.result(distinct: true).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /court_dates/1
  def show
    @court_attendances = @court_date.court_attendances.paginate(:per_page => 10, :page => params[:court_attendances_page])
  end

  # GET /court_dates/new
  def new
    @court_date = CourtDate.new
  end

  # GET /court_dates/1/edit
  def edit
  end

  # POST /court_dates
  def create
    @court_date = CourtDate.new(court_date_params)

    if @court_date.save
      redirect_to @court_date, notice: 'Court date was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /court_dates/1
  def update
    if @court_date.update(court_date_params)
      redirect_to @court_date, notice: 'Court date was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /court_dates/1
  def destroy
    @court_date.destroy
    redirect_to @court_date.client_file, notice: 'Court date was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_court_date
    @court_date = CourtDate.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def court_date_params

    params.require(:court_date).permit(:court_date, :client_file_id, :court_id, :court_date_type_id, :journey_id)

  end
end
