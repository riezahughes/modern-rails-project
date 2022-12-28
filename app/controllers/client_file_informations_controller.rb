class ClientFileInformationsController < AuthoritativeController
  before_action :set_client_file_information, only: [:show, :edit, :update, :destroy]
  # GET /client_file_informations
  def index
    @search = ClientFileInformation.ransack(params[:q])
    @client_file_informations = @search.result(distinct: true).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /client_file_informations/1
  def show
  end

  # GET /client_file_informations/new
  def new
    @client_file_information = ClientFileInformation.new
  end

  # GET /client_file_informations/1/edit
  def edit
  end

  # POST /client_file_informations
  def create
    @client_file_information = ClientFileInformation.new(client_file_information_params)

    if @client_file_information.save
      redirect_to @client_file_information, notice: 'Client file information was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /client_file_informations/1
  def update
    if @client_file_information.update(client_file_information_params)
      redirect_to @client_file_information, notice: 'Client file information was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /client_file_informations/1
  def destroy
    @client_file_information.destroy
    redirect_to client_file_informations_url, notice: 'Client file information was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_client_file_information
    @client_file_information = ClientFileInformation.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def client_file_information_params

    params.require(:client_file_information).permit(:name)

  end
end
