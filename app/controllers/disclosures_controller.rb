class DisclosuresController < AuthoritativeController
  include DocumentStoreDocumentActions

  before_action :set_disclosure, only: [:show, :edit, :update, :destroy]
  # GET /disclosures
  def index
    @search = Disclosure.ransack(params[:q])
    @disclosures = @search.result(distinct: true).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /disclosures/1
  def show
  end

  # GET /disclosures/new
  def new
    @disclosure = Disclosure.new
  end

  # GET /disclosures/1/edit
  def edit
  end

  # POST /disclosures
  def create
    @disclosure = Disclosure.new(disclosure_params)

    if @disclosure.save
      redirect_to @disclosure, notice: 'Disclosure was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /disclosures/1
  def update
    if @disclosure.update(disclosure_params)
      redirect_to @disclosure, notice: 'Disclosure was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /disclosures/1
  def destroy
    @disclosure.destroy
    respond_to do |format|
      format.html { redirect_to disclosures_url, notice: 'Disclosure was successfully destroyed.' }
      format.js { head :ok, content_type: "text/html" }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_disclosure
    @disclosure = Disclosure.find(params[:id])
  end

  def set_document_owner
    @document_owner = Disclosure.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def disclosure_params

    params.require(:disclosure).permit(:client_file_id)

  end

end

def sort_column
  params[:sort] || Disclosure.column_names.first
end

def sort_direction
  params[:direction] || "asc"
end

