class CourtDateTypesController < AuthoritativeController
  before_action :set_court_date_type, only: [:show, :edit, :update, :destroy]
  # GET /court_date_types
  def index
    @search = CourtDateType.ransack(params[:q])
    @court_date_types = @search.result(distinct: true).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /court_date_types/1
  def show
  end

  # GET /court_date_types/new
  def new
    @court_date_type = CourtDateType.new
  end

  # GET /court_date_types/1/edit
  def edit
  end

  # POST /court_date_types
  def create
    @court_date_type = CourtDateType.new(court_date_type_params)

    if @court_date_type.save
      redirect_to @court_date_type, notice: 'Court date type was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /court_date_types/1
  def update
    if @court_date_type.update(court_date_type_params)
      redirect_to @court_date_type, notice: 'Court date type was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /court_date_types/1
  def destroy
    @court_date_type.destroy
    redirect_to court_date_types_url, notice: 'Court date type was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_court_date_type
    @court_date_type = CourtDateType.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def court_date_type_params

    params.require(:court_date_type).permit(:name, :preparation, :following_court_date_type_id)

  end
end
