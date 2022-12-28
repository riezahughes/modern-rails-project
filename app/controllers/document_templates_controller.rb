class DocumentTemplatesController < AuthoritativeController
  before_action :set_document_template, only: [:show, :edit, :update, :destroy, :download]
  before_action :set_example_file, only: [:new, :edit, :new_mutiple_file_upload]

  def autocomplete_document_templates_name
    document_templates = DocumentTemplate
      .where(template_type: params[:document_template_type])
      .where('name LIKE ?', "%#{params[:term]}%")
      .order(name: :asc).limit(10)

    render json: document_templates.map { |document_template| {id: document_template.id,
                                         label: document_template.to_s,
                                         value: document_template.to_s} }
  end

  # GET /document_templates
  def index
    @search = DocumentTemplate.ransack(params[:q])
    @document_templates = @search.result(distinct: true).paginate(per_page: 10, page: params[:page])
  end

  # GET /document_templates/1
  def show
  end

  # GET /document_templates/new
  def new
    @document_template = DocumentTemplate.new
    @templateables = DocumentTemplateable.classes.map { |templateable| templateable.new }
  end

  # GET /document_templates/by_category
  def by_category
    @document_templates = DocumentTemplate.where(category: by_category_params[:category]).select(:id, :name).order(:name)

    respond_to do |format|
       format.js { render json: @document_templates, status: :ok }
     end
  end

  # GET /new_mutiple_file_upload
  def new_mutiple_file_upload
    @document_templates = [DocumentTemplate.new]
    @templateables = DocumentTemplateable.classes.map { |templateable| templateable.new }
  end

  # GET /document_templates/1/edit
  def edit
    @templateables = DocumentTemplateable.classes.map { |templateable| templateable.new }
  end

  # POST /document_templates
  def create
    @document_template = DocumentTemplate.new(document_template_params)
    @templateables = DocumentTemplateable.classes.map { |templateable| templateable.new }

    if @document_template.save
      @document_template.create_document
      redirect_to @document_template, notice: 'Document template was successfully created.'
    else
      render :new
    end
  end

  # POST /multiple_file_upload
  def multiple_file_upload
    saved_document_templates = document_templates_params[:template_files].map do |template_file|
      name = template_name_from_file_name template_file.original_filename

      if File.extname(template_file.original_filename) == '.doc'
        converted_file = DataImport::DocFile.convert_to_docx_at_tmp_location template_file.tempfile.path
        template_file.tempfile = File.new converted_file
        template_file.original_filename = template_file.original_filename.gsub(/\.doc$/, '\.docx')
      end

      document_template = DocumentTemplate.find_or_initialize_by(name: name) do |document_template|
        document_template.template_file_content_type = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        document_template.template_type = document_templates_params[:template_type],
        document_template.category = document_templates_params[:category]
      end

      document_template.template_file = template_file
      document_template
    end
    .map do |document_template|
      saved_succesfully = document_template.save
      unless saved_succesfully
        Rails.logger.warn "Failed to save document template: \"#{document_template}\", errors: #{document_template.errors.full_messages.join(', ')}"
      end
      saved_succesfully
    end

    unless saved_document_templates.all?
      redirect_to document_templates_url,
       alert: "Failed to save #{saved_document_templates.count(false)} out of #{saved_document_templates.count} document templates."
    else
      redirect_to document_templates_url, notice: "#{saved_document_templates.count} document templates were successfully saved."
    end
  end

  # PATCH/PUT /document_templates/1
  def update
    @templateables = DocumentTemplateable.classes.map { |templateable| templateable.new }

    if @document_template.update(document_template_params)
      @document_template.create_document
      redirect_to @document_template, notice: 'Document template was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /document_templates/1
  def destroy
    if @document_template.destroy
      redirect_to document_templates_url, notice: 'Document template was successfully destroyed.'
    else
      redirect_to document_templates_url, alert: "Failed to delete document template: #{@document_template.errors.first[1]}"
    end
  end

  # GET /document_templates/1/download
  def download

    respond_to do |format|
      if @document_template.template_file.file?
        format.html { send_file @document_template.template_file.path, type: @document_template.template_file_content_type, disposition: 'inline' }
      else
        format.html { raise ActionController::RoutingError.new('Not Found') }
      end

      if @document_template.template_file.exists?(:pdf)
        format.pdf { send_file @document_template.template_file.path(:pdf), type: 'application/pdf', disposition: 'inline' }
      else
        format.pdf { raise ActionController::RoutingError.new('Not Found') }
      end
    end

  end

  private

  def template_name_from_file_name(file_name)
    File.basename(file_name, File.extname(file_name))
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_document_template
    @document_template = DocumentTemplate.find(params[:id])
  end

  def set_example_file
    @example_file = ClientFile.find_by_file_number(params[:example_file_number])
  end

  # Only allow a trusted parameter "white list" through.
  def document_template_params
    params.require(:document_template).permit(:alfresco_id, :name, :category, :template_file, :template_type)
  end

  def document_templates_params
    params.require(:document_template).permit(:template_type, :category, template_files: [])
  end

  def by_category_params
    params.permit(:category)
  end
end
