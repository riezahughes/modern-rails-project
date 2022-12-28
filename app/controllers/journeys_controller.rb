class JourneysController < AuthoritativeController
  include HideDefaultList
  include WorkControllerHelper

  before_action :set_journey, only: [:show, :edit, :update, :destroy]
  # GET /journeys
  def index
    @search = Journey.ransack(params[:q])
    @search.sorts = ['departure_date_sort desc'] if @search.sorts.empty?
    @journeys = hidden_results(@search) do |search|
      search.duration_select.joins(:user)
    end.paginate(:per_page => 10, :page => params[:page])
  end

  # GET /journeys/1
  def show
    @travels = @journey.travels.order(created_at: :desc).paginate(:per_page => 4, :page => params[:travels_page])
    @meetings = @journey.meetings.order(created_at: :desc).paginate(:per_page => 10, :page => params[:meetings_page])
    @court_dates = @journey.court_dates.order(created_at: :desc).paginate(:per_page => 10, :page => params[:court_dates_page])
  end

  # GET /journeys/new
  def new
    @journey = Journey.new
    @travel = Travel.new
    @meeting = Meeting.new
    @court_date = CourtDate.new
  end

  # GET /journeys/1/edit
  def edit
    @travel = Travel.new
    @meeting = Meeting.new
    @court_date = CourtDate.new
  end

  # POST /journeys
  def create
    @journey = Journey.new(journey_params)

    @travels = travels_params.map do |travel_params|
      travel = Travel.new(travel_params.except(:work))
      travel.journey = @journey
      add_new_work travel, nil, travel_params[:work].merge({user_id: @journey.user_id})

      travel
    end

    @journey.travels = @travels

    @journey.errors.add(:base, 'Must add at least one travel') if @travels.empty?

    @meetings = meetings_params.map do |meeting_param|
      meeting_id = meeting_param[:id]
      Meeting.find(meeting_id)
    end

    @journey.meetings = @meetings

    if !@travels.empty? && @journey.save
      redirect_to @journey, notice: 'Journey was successfully created.'
    else

      @travel = Travel.new
      @meeting = Meeting.new
      @court_date = CourtDate.new
      render :new
    end
  end

  # POST /journeys/add_travel_to_form
  def add_travel_to_form

    @journey = Journey.new
    @travel = Travel.new(add_travel_to_form_params)
    @travel.journey = @journey
    add_new_work @travel

    respond_to do |format|
      if @travel.valid?
        format.js
      else
        format.js { render json: @travel.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /journeys/add_meeting_to_form
  def add_meeting_to_form
    @journey = Journey.new
    meeting_id = add_meeting_to_form_params[:id]
    @meeting = Meeting.find(meeting_id)

    respond_to do |format|
      format.js
    end
  end

  # POST /journeys/add_court_date_to_form
  def add_court_date_to_form
    @journey = Journey.new
    court_date_id = add_court_date_to_form_params[:id]
    @court_date = CourtDate.find(court_date_id)

    respond_to do |format|
      format.js
    end
  end

  # PATCH/PUT /journeys/1
  def update
    if @journey.update(journey_params)
      redirect_to @journey, notice: 'Journey was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /journeys/1
  def destroy
    @journey.destroy
    redirect_to journeys_url, notice: 'Journey was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_journey
    @journey = Journey.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def journey_params
    params.require(:journey).permit(:user_id, :client_file_count)
  end

  def travels_params
    params.permit(travels: [:travel_method_id,
                              :origin,
                              :destination,
                              :mileage,
                              :parking_costs,
                              :toll_costs,
                              :other_costs,
                              work: [:start_date, :end_date]])[:travels] || []
  end

  def meetings_params
    params.permit(meetings: [:id])[:meetings] || []
  end

  def add_travel_to_form_params
    params.require(:travel).permit(:origin, :destination, :mileage, :parking_costs, :toll_costs, :other_costs, :journey_id, :travel_method_id)
  end

  def add_meeting_to_form_params
    params.require(:meeting).permit(:id)
  end

  def add_court_date_to_form_params
    params.require(:court_date).permit(:id)
  end
end
