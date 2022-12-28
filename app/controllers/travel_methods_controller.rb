class TravelMethodsController < AuthoritativeController
  before_action :set_travel_method, only: [:show, :edit, :update, :destroy]
  # GET /travel_methods
  def index
    @search = TravelMethod.ransack(params[:q])
    @travel_methods = @search.result(distinct: true).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /travel_methods/1
  def show
  end

  # GET /travel_methods/new
  def new
    @travel_method = TravelMethod.new
  end

  # GET /travel_methods/1/edit
  def edit
  end

  # POST /travel_methods
  def create
    @travel_method = TravelMethod.new(travel_method_params)

    if @travel_method.save
      redirect_to @travel_method, notice: 'Travel method was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /travel_methods/1
  def update
    if @travel_method.update(travel_method_params)
      redirect_to @travel_method, notice: 'Travel method was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /travel_methods/1
  def destroy
    @travel_method.destroy
    redirect_to travel_methods_url, notice: 'Travel method was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_travel_method
    @travel_method = TravelMethod.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def travel_method_params

    params.require(:travel_method).permit(:name)

  end
end

def sort_column
  params[:sort] || TravelMethod.column_names.first
end

def sort_direction
  params[:direction] || "asc"
end

