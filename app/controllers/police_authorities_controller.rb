class PoliceAuthoritiesController < AuthoritativeController
  before_action :set_police_authority, only: [:show, :edit, :update, :destroy]
  # GET /police_authorities
  def index
    @search = PoliceAuthority.ransack(params[:q])
    @police_authorities = @search.result(distinct: true).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /police_authorities/1
  def show
  end

  # GET /police_authorities/new
  def new
    @police_authority = PoliceAuthority.new
  end

  # GET /police_authorities/1/edit
  def edit
  end

  # POST /police_authorities
  def create
    @police_authority = PoliceAuthority.new(police_authority_params)

    if @police_authority.save
      redirect_to @police_authority, notice: 'Police authority was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /police_authorities/1
  def update
    if @police_authority.update(police_authority_params)
      redirect_to @police_authority, notice: 'Police authority was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /police_authorities/1
  def destroy
    @police_authority.destroy
    redirect_to police_authorities_url, notice: 'Police authority was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_police_authority
    @police_authority = PoliceAuthority.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def police_authority_params

    params.require(:police_authority).permit(:name, :address, :city, :police_constable, :telephone)

  end
end
