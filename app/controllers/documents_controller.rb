class DocumentsController < AuthoritativeController
  include ClientFileChildControllerHelper

  before_action :set_document, only: [:show, :edit, :update, :destroy, :download]
  before_action :set_documentable_type, only: [:new, :create, :edit, :update]

  autocomplete :client_file, :file_number

  def autocomplete_client_name
    clients = Client.client_name_scope(params[:term]).limit(10)
    render json: clients.map { |client| {id: client.id,
                                         label: "#{client.full_name} (#{client.formatted_birth_date})",
                                         value: client.full_name} }
  end

  # GET /documents
  def index
    @search = Document.ransack(params[:q])
    @documents = @search.result(distinct: true).paginate(per_page: 10, page: params[:page])
  end

  # GET /documents/1
  def show
  end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  def create
    @document = Document.new(document_params)

    if @document.save
      @document.create_document
      redirect_to @document, notice: 'Document was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /documents/1
  def update
    if @document.update(document_params)
      redirect_to @document, notice: 'Document was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /documents/1
  def destroy
    @document.destroy
    redirect_to @document.documentable, notice: 'Document was successfully destroyed.'
  end

  # GET /document_templates/1/download
  def download

    respond_to do |format|
      if @document.document_file.file?
        format.html { send_file @document.document_file.path, type: @document.document_file_content_type, disposition: 'inline' }
        format.pdf { send_data @document.pdf_preview,
                      file_name: 'pdf_preview.pdf',
                      type: 'application/pdf',
                      disposition: 'inline',
                      stream: 'true',
                      buffer_size: '4096' }
      else
        format.html { raise ActionController::RoutingError.new('Not Found') }
      end
    end

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_document
    @document = Document.find(params[:id])
  end

  def set_documentable_type
    if params[:parent_type]
      begin
        @documentable_type = params[:parent_type].camelize.constantize
      rescue
        @documentable_type = nil
      end
    else
      @documentable_type = nil
    end
  end

  # Only allow a trusted parameter "white list" through.
  def document_params
    params.require(:document).permit(:description, :documentable_id, :documentable_type, :document_file)
  end
end
