class CourtTypesController < AuthoritativeController
  before_action :set_court_type, only: [:show, :edit, :update, :destroy]
  # GET /court_types
  def index
    @search = CourtType.ransack(params[:q])
    @court_types = @search.result(distinct: true).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /court_types/1
  def show
  end

  # GET /court_types/new
  def new
    @court_type = CourtType.new
  end

  # GET /court_types/1/edit.
  def edit
  end

  # POST /court_types
  def create
    @court_type = CourtType.new(court_type_params)

    if @court_type.save
      redirect_to @court_type, notice: 'Court type was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /court_types/1
  def update
    if @court_type.update(court_type_params)
      redirect_to @court_type, notice: 'Court type was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /court_types/1
  def destroy
    @court_type.destroy
    redirect_to court_types_url, notice: 'Court type was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_court_type
    @court_type = CourtType.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def court_type_params

    params.require(:court_type).permit(:name, :recipient, :court_official_id)

  end
end
