class ProcuratorFiscalsController < AuthoritativeController
  before_action :set_procurator_fiscal, only: [:show, :edit, :update, :destroy]
  # GET /procurator_fiscals
  def index
    @search = ProcuratorFiscal.ransack(params[:q])
    @procurator_fiscals = @search.result(distinct: true).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /procurator_fiscals/1
  def show
  end

  # GET /procurator_fiscals/new
  def new
    @procurator_fiscal = ProcuratorFiscal.new
  end

  # GET /procurator_fiscals/1/edit
  def edit
  end

  # POST /procurator_fiscals
  def create
    @procurator_fiscal = ProcuratorFiscal.new(procurator_fiscal_params)

    if @procurator_fiscal.save
      redirect_to @procurator_fiscal, notice: 'Procurator fiscal was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /procurator_fiscals/1
  def update
    if @procurator_fiscal.update(procurator_fiscal_params)
      redirect_to @procurator_fiscal, notice: 'Procurator fiscal was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /procurator_fiscals/1
  def destroy
    @procurator_fiscal.destroy
    redirect_to procurator_fiscals_url, notice: 'Procurator fiscal was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_procurator_fiscal
    @procurator_fiscal = ProcuratorFiscal.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def procurator_fiscal_params

    params.require(:procurator_fiscal).permit(:name, :address, :telephone, :fax)

  end
end
