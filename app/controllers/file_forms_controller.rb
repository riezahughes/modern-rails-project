class FileFormsController < AuthoritativeController
  include HideDefaultList
  include DocumentTemplateableActions
  include ClientFileChildControllerHelper
  include DocumentTemplateableHelper
  before_action :set_file_form, only: [:show, :edit, :update, :destroy]

  autocomplete :client_file, :file_number
  # GET /file_forms
  def index
    @search = FileForm.ransack(params[:q])
    @file_forms = hidden_results(@search).paginate(per_page: 10, page: params[:page])
  end

  # GET /file_forms/1
  def show
  end

  # GET /file_forms/new
  def new
    @file_form = FileForm.new
  end

  # GET /file_forms/1/edit
  def edit
  end

  # POST /file_forms
  def create
    @file_form = FileForm.new(file_form_params)
    @file_form.created_by = current_user
    save_templated_document_to_templateable @file_form

    if @file_form.save
      redirect_to @file_form, notice: 'File form was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /file_forms/1
  def update
    if @file_form.update(file_form_params)
      redirect_to @file_form, notice: 'File form was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /file_forms/1
  def destroy
    @file_form.destroy
    redirect_to @file_form.client_file, notice: 'File form was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_file_form
    @file_form = FileForm.find(params[:id])
  end

  def set_document_templateable
    @document_templateable = FileForm.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def file_form_params
    params.require(:file_form).permit(:form_date, :description, :chargeable, :created_by_id, :client_file_id, :document_template_id, :templated_document)
  end
end
