class CiviliansController < AuthoritativeController
  include HideDefaultList
  include WitnessControllerHelper
  before_action :set_civilian, only: [:show, :edit, :update, :destroy]

  # GET /civilians
  def index
    @search = Civilian.ransack(params[:q])
    @civilians = hidden_results(@search).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /civilians/1
  def show
  end

  # GET /civilians/new
  def new
    @civilian = Civilian.new
  end

  # GET /civilians/1/edit
  def edit
  end

  # POST /civilians
  def create
    @civilian = Civilian.new(civilian_params)
    add_witnesses @civilian

    if @civilian.save
      redirect_to @civilian, notice: 'Civilian was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /civilians/1
  def update

    update_witnesses @civilian
    if @civilian.update(civilian_params)
      redirect_to @civilian, notice: 'Civilian was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /civilians/1
  def destroy
    @civilian.destroy
    redirect_to civilians_url, notice: 'Civilian was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_civilian
    @civilian = Civilian.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def civilian_params
    params.require(:civilian).permit(:title, :name, :address, :telephone)
  end
end
