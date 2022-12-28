class ClientFileTypesController < AuthoritativeController
  before_action :set_client_file_type, only: [:show, :edit, :update, :destroy]
  # GET /client_file_types
  def index
    @search = ClientFileType.ransack(params[:q])
    @client_file_types = @search.result(distinct: true).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /client_file_types/1
  def show
  end

  # GET /client_file_types/new
  def new
    @client_file_type = ClientFileType.new
  end

  # GET /client_file_types/1/edit
  def edit
  end

  # POST /client_file_types
  def create
    @client_file_type = ClientFileType.new(client_file_type_params)

    if @client_file_type.save
      redirect_to @client_file_type, notice: 'Client file type was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /client_file_types/1
  def update
    if @client_file_type.update(client_file_type_params)
      redirect_to @client_file_type, notice: 'Client file type was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /client_file_types/1
  def destroy
    @client_file_type.destroy
    redirect_to client_file_types_url, notice: 'Client file type was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_client_file_type
    @client_file_type = ClientFileType.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def client_file_type_params
    params.require(:client_file_type).permit(:name, :prefixes, :folder_colour)
  end
end
