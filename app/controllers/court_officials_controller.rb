class CourtOfficialsController < AuthoritativeController
  before_action :set_court_official, only: [:show, :edit, :update, :destroy]
  # GET /court_officials
  def index
    @search = CourtOfficial.ransack(params[:q])
    @court_officials = @search.result(distinct: true).joins(:court_official_type).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /court_officials/1
  def show
  end

  # GET /court_officials/new
  def new
    @court_official = CourtOfficial.new
  end

  # GET /court_officials/1/edit
  def edit
  end

  # POST /court_officials
  def create
    @court_official = CourtOfficial.new(court_official_params)

    if @court_official.save
      redirect_to @court_official, notice: 'Court official was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /court_officials/1
  def update
    if @court_official.update(court_official_params)
      redirect_to @court_official, notice: 'Court official was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /court_officials/1
  def destroy
    @court_official.destroy
    redirect_to court_officials_url, notice: 'Court official was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_court_official
    @court_official = CourtOfficial.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def court_official_params

    params.require(:court_official).permit(:name, :court_official_type_id)

  end
end
