class DebitEntriesController < AuthoritativeController
  include HideDefaultList
  include DocumentTemplateableActions
  include ClientFileChildControllerHelper
  include DocumentTemplateableHelper
  before_action :set_debit_entry, only: [:show, :edit, :update, :destroy]
  autocomplete :client_file, :file_number

  # GET /debit_entries
  def index
    @search = DebitEntry.ransack(params[:q])
    @debit_entries = hidden_results(@search).paginate(per_page: 10, page: params[:page])
  end

  # GET /debit_entries/1
  def show
  end

  # GET /debit_entries/new
  def new
    @debit_entry = DebitEntry.new
  end

  # GET /debit_entries/1/edit
  def edit
  end

  # POST /debit_entries
  def create
    @debit_entry = DebitEntry.new(debit_entry_params)
    @debit_entry.created_by = current_user
    save_templated_document_to_templateable @debit_entry

    if @debit_entry.save
      redirect_to @debit_entry, notice: 'Debit entry was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /debit_entries/1
  def update
    if @debit_entry.update(debit_entry_params)
      redirect_to @debit_entry, notice: 'Debit entry was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /debit_entries/1
  def destroy
    @debit_entry.destroy
    redirect_to @debit_entry.client_file, notice: 'Debit entry was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_debit_entry
    @debit_entry = DebitEntry.find(params[:id])
  end

  def set_document_templateable
    @document_templateable = DebitEntry.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def debit_entry_params
    params.require(:debit_entry).permit(:debit_entry_date, :description, :vat, :amount, :client_file_id, :document_template_id, :created_by_id, :payment_method)
  end
end
