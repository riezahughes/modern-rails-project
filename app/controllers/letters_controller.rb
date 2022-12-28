class LettersController < AuthoritativeController
  include HideDefaultList
  include NotifiableActions
  include ChargeableItemTriggers
  include DocumentTemplateableActions
  include DocumentTemplateableHelper
  include ClientFileChildControllerHelper

  before_action :set_letter, only: [:show, :edit, :update, :destroy]

  autocomplete :client_file, :file_number

  # GET /letters
  def index
    @search = Letter.ransack(params[:q])
    @search.sorts = ['letter_date desc'] if @search.sorts.empty?
    @letters = hidden_results(@search).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /letters/1
  def show
  end

  # GET /letters/new
  def new
    @letter = Letter.new
  end

  # GET /letters/1/edit
  def edit
  end

  # POST /letters
  def create
    @letter = Letter.new(letter_params)
    @letter.created_by = current_user
    @chargeable_item = @letter
    save_templated_document_to_templateable @letter
    set_word_count @letter

    if @letter.save
      redirect_to @letter, notice: 'Letter was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /letters/1
  def update
    if @letter.update(letter_params)
      redirect_to @letter, notice: 'Letter was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /letters/1
  def destroy
    @letter.destroy
    redirect_to @letter.client_file, notice: 'Letter was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_letter
    @letter = Letter.find(params[:id])
  end

  def set_notifiable
    @notifiable = Letter.find(params[:id])
  end

  def set_document_templateable
    @document_templateable = Letter.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def letter_params

    params.require(:letter).permit(:letter_date,
                                    :description,
                                    :length,
                                    :chargeable,
                                    :high_legal,
                                    :client_file_id,
                                    :document_template_id)

  end
end
