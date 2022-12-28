class UserTypesController < AuthoritativeController
  before_action :set_user_type, only: [:show, :edit, :update, :destroy]
  # GET /user_types
  def index
    @search = UserType.ransack(params[:q])
    @user_types = @search.result(distinct: true).paginate(:per_page => 10, :page => params[:page])
  end
  # GET /user_types/1
  def show
  end

  # GET /user_types/new
  def new
    @user_type = UserType.new
  end

  # GET /user_types/1/edit
  def edit
  end

  # POST /user_types
  def create
    @user_type = UserType.new(user_type_params)

if @user_type.save
      redirect_to @user_type, notice: 'User type was successfully created.'
    else
      render :new
    end
  end
  # PATCH/PUT /user_types/1
  def update
    if @user_type.update(user_type_params)
      redirect_to @user_type, notice: 'User type was successfully updated.'
    else
      render :edit
    end
  end
  # DELETE /user_types/1
def destroy
  @user_type.destroy
    redirect_to user_types_url, notice: 'User type was successfully destroyed.'
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_type
  @user_type = UserType.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_type_params
  params.require(:user_type).permit(:name, :qualified_solicitor)
end
end
