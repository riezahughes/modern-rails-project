class MeetingTypesController < AuthoritativeController
  before_action :set_meeting_type, only: [:show, :edit, :update, :destroy]
  # GET /meeting_types
  def index
    @search = MeetingType.ransack(params[:q])
    @meeting_types = @search.result(distinct: true).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /meeting_types/1
  def show
  end

  # GET /meeting_types/new
  def new
    @meeting_type = MeetingType.new
  end

  # GET /meeting_types/1/edit
  def edit
  end

  # POST /meeting_types
  def create
    @meeting_type = MeetingType.new(meeting_type_params)

    if @meeting_type.save
      redirect_to @meeting_type, notice: 'Meeting type was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /meeting_types/1
  def update
    if @meeting_type.update(meeting_type_params)
      redirect_to @meeting_type, notice: 'Meeting type was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /meeting_types/1
  def destroy
    @meeting_type.destroy
    redirect_to meeting_types_url, notice: 'Meeting type was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_meeting_type
    @meeting_type = MeetingType.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def meeting_type_params

    params.require(:meeting_type).permit(:name)

  end
end

def sort_column
  params[:sort] || MeetingType.column_names.first
end

def sort_direction
  params[:direction] || "asc"
end

