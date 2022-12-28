class LocationTypesController < AuthoritativeController
  before_action :set_location_type, only: [:show, :edit, :update, :destroy]
  # GET /location_types
  def index
    @search = LocationType.ransack(params[:q])
    @location_types = @search.result(distinct: true).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /location_types/1
  def show
  end

  # GET /location_types/new
  def new
    @location_type = LocationType.new
  end

  # GET /location_types/1/edit
  def edit
  end

  # POST /location_types
  def create
    @location_type = LocationType.new(location_type_params)

    if @location_type.save
      redirect_to @location_type, notice: 'Location type was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /location_types/1
  def update
    if @location_type.update(location_type_params)
      redirect_to @location_type, notice: 'Location type was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /location_types/1
  def destroy
    @location_type.destroy
    redirect_to location_types_url, notice: 'Location type was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_location_type
    @location_type = LocationType.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def location_type_params

    params.require(:location_type).permit(:name)

  end
end
