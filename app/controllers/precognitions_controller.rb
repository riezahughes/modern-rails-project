class PrecognitionsController < AuthoritativeController
  include DocumentTemplateableActions
  before_action :set_precognition, only: [:show, :edit, :update, :destroy]
  # GET /precognitions
  def index
    @search = Precognition.ransack(params[:q])
    @precognitions = @search.result(distinct: true).paginate(per_page: 10, page: params[:page])
  end

  # GET /precognitions/1
  def show
  end

  # GET /precognitions/new
  def new
    @meeting_id = params[:meeting_id]
    @meeting = Meeting.find_by_id(@meeting_id)
    @precognition = Precognition.new
  end

  # GET /precognitions/1/edit
  def edit
    @meeting_id = params[:meeting_id] || @precognition.meeting_id
    @meeting = Meeting.find_by_id(@meeting_id)
  end

  # POST /precognitions
  def create
    @precognition = Precognition.new(precognition_params)
    @meeting_id = params[:meeting_id]
    @meeting = Meeting.find_by_id(@meeting_id)

    if @precognition.save
      redirect_to @precognition, notice: 'Precognition was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /precognitions/1
  def update
    @meeting_id = params[:meeting_id] || @precognition.meeting_id
    @meeting = Meeting.find_by_id(@meeting_id)

    if @precognition.update(precognition_params)
      redirect_to @precognition, notice: 'Precognition was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /precognitions/1
  def destroy
    @precognition.destroy
    redirect_to precognitions_url, notice: 'Precognition was successfully destroyed.'
    end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_precognition
    @precognition = Precognition.find(params[:id])
  end

  def set_document_templateable
    @document_templateable = Precognition.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def precognition_params
    params.require(:precognition).permit(:description, :meeting_id, :document_template_id, :templated_document, :length, :date_framed)
  end
end
