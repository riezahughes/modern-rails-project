class TravelsController < AuthoritativeController
  include WorkControllerHelper
  include ChargeableItemTriggers
  before_action :set_travel, only: [:show, :edit, :update, :destroy]
  before_action :set_journey, only: [:new, :edit, :create, :update]

  autocomplete :journey, :identifier

  def autocomplete_journey_identifier
    journeys = Journey.journey_search_scope(params[:term]).limit(10)
    render json: journeys.map { |journey| {id: journey.id,
                                           label: journey.formatted_identifier,
                                           value: journey.formatted_identifier} }
  end

  # GET /travels
  def index
    @search = Travel.ransack(params[:q])
    @travels = @search.result(distinct: true).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /travels/1
  def show
  end

  # GET /travels/new
  def new
    @travel = Travel.new

  end

  # GET /travels/1/edit
  def edit
  end

  # POST /travels
  def create
    @travel = Travel.new(travel_params)
    add_new_work @travel
    @chargeable_item = @travel

    if @travel.save
      redirect_to @travel, notice: 'Travel was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /travels/1
  def update

    update_work @travel
    if @travel.update(travel_params)
      redirect_to @travel.journey, notice: 'Travel was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /travels/1
  def destroy
    journey = @travel.journey
    @travel.destroy
    redirect_to journey, notice: 'Travel was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_travel
    @travel = Travel.find(params[:id])
  end

  def set_journey
    if params[:journey_id]
      @journey_id = params[:journey_id]
      @journey = Journey.find_by_id(@journey_id)
    end
  end

  # Only allow a trusted parameter "white list" through.
  def travel_params

    params.require(:travel).permit(:origin, :destination, :mileage, :parking_costs, :toll_costs, :other_costs, :journey_id, :travel_method_id)

  end
end
