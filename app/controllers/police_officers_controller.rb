class PoliceOfficersController < AuthoritativeController
  include WitnessControllerHelper
  before_action :set_police_officer, only: [:show, :edit, :update, :destroy]
  # GET /police_officers
  def index
    @search = PoliceOfficer.ransack(params[:q])
    @police_officers = @search.result(distinct: true).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /police_officers/1
  def show
  end

  # GET /police_officers/new
  def new
    @police_officer = PoliceOfficer.new
    @police_authorities = PoliceAuthority.all
  end

  # GET /police_officers/1/edit
  def edit
    @police_authorities = PoliceAuthority.all
  end

  # POST /police_officers
  def create
    @police_officer = PoliceOfficer.new(police_officer_params)
    add_witnesses @police_officer

    if @police_officer.save
      redirect_to @police_officer, notice: 'Police officer was successfully created.'
    else
      @police_authorities = PoliceAuthority.all
      render :new
    end
  end

  # PATCH/PUT /police_officers/1
  def update
    @police_authorities = PoliceAuthority.all

    update_witnesses @police_officer
    if @police_officer.update(police_officer_params)
      redirect_to @police_officer, notice: 'Police officer was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /police_officers/1
  def destroy
    @police_officer.destroy
    redirect_to police_officers_url, notice: 'Police officer was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_police_officer
    @police_officer = PoliceOfficer.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def police_officer_params

    params.require(:police_officer).permit(:title, :name, :pc_number, :police_authority_id)

  end
end
