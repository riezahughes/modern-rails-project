class CourtOfficialTypesController < AuthoritativeController
  before_action :set_court_official_type, only: [:show, :edit, :update, :destroy]
  # GET /court_official_types
  def index
    @search = CourtOfficialType.ransack(params[:q])
    @court_official_types = @search.result(distinct: true).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /court_official_types/1
  def show
  end

  # GET /court_official_types/new
  def new
    @court_official_type = CourtOfficialType.new
  end

  # GET /court_official_types/1/edit
  def edit
  end

  # POST /court_official_types
  def create
    @court_official_type = CourtOfficialType.new(court_official_type_params)

    if @court_official_type.save
      redirect_to @court_official_type, notice: 'Court official type was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /court_official_types/1
  def update
    if @court_official_type.update(court_official_type_params)
      redirect_to @court_official_type, notice: 'Court official type was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /court_official_types/1
  def destroy
    @court_official_type.destroy
    redirect_to court_official_types_url, notice: 'Court official type was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_court_official_type
    @court_official_type = CourtOfficialType.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def court_official_type_params
    params.require(:court_official_type).permit(:name)
  end
end
