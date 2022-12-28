class JurisdictionsController < AuthoritativeController
  before_action :set_jurisdiction, only: [:show, :edit, :update, :destroy]
  # GET /jurisdictions
  def index
    @search = Jurisdiction.ransack(params[:q])
    @jurisdictions = @search.result(distinct: true).paginate(:per_page => 10, :page => params[:page])
  end
  # GET /jurisdictions/1
  def show
  end

  # GET /jurisdictions/new
  def new
    @jurisdiction = Jurisdiction.new
  end

  # GET /jurisdictions/1/edit
  def edit
  end

  # POST /jurisdictions
  def create
    @jurisdiction = Jurisdiction.new(jurisdiction_params)

if @jurisdiction.save
      redirect_to @jurisdiction, notice: 'Jurisdiction was successfully created.'
    else
      render :new
    end
  end
  # PATCH/PUT /jurisdictions/1
  def update
    if @jurisdiction.update(jurisdiction_params)
      redirect_to @jurisdiction, notice: 'Jurisdiction was successfully updated.'
    else
      render :edit
    end
  end
  # DELETE /jurisdictions/1
def destroy
  @jurisdiction.destroy
    redirect_to jurisdictions_url, notice: 'Jurisdiction was successfully destroyed.'
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jurisdiction
  @jurisdiction = Jurisdiction.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def jurisdiction_params
  params.require(:jurisdiction).permit(:name)
end
end
