class LocationsController < AuthoritativeController
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  # GET /locations
  def index
    @search = Location.ransack(params[:q])
    @locations = @search.result(distinct: true).joins(:location_type).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /locations/1
  def show
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/client_report
  def client_report
    @location = Location.find_by_id(params[:location_id])
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  def create
    @location = Location.new(location_params)

    if @location.save
      redirect_to @location, notice: 'Location was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /locations/1
  def update
    if @location.update(location_params)
      redirect_to @location, notice: 'Location was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /locations/1
  def destroy
    @location.destroy
    redirect_to locations_url, notice: 'Location was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_location
    @location = Location.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def location_params

    params.require(:location).permit(:name, :address, :telephone, :location_type_id)

  end
end
