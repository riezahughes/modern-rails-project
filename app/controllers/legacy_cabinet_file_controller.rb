class LegacyCabinetFileController < AuthoritativeController
  skip_authorize_resource

  skip_before_action :verify_authenticity_token
  # TODO: Should be removed in the long run, mechanism to fetch files from Autocase file server

  # PUT /fetch_file
  def fetch_file

    @document_templateable = find_documentable
    @cabinet_location = @document_templateable.cabinet_location

    if @cabinet_location
      file_contents = DataImport::DocFile.read_file(@cabinet_location)
      file_name = DataImport::DocFile.file_name(@cabinet_location)

      templated_document = @document_templateable.import_templated_document(file_contents, file_name)
      templated_document_path = AlfrescoTemplatedDocument.document_path templated_document

      @templated_document = TemplatedDocument.new(alfresco_id: templated_document.cmis_object_id,
                                                        document_path: templated_document_path,
                                                        document_templateable: @document_templateable,
                                                        document_template: DocumentTemplate.find_by_template_type(@document_templateable.class.name))
      # @documentable.save!

      if @templated_document.save
        respond_to do |format|
          format.js
        end
      else
        respond_to do |format|
          format.js { render status: 422, json: "#{@document_templateable} needs to have at least one template with type #{@document_templateable.class.name}".to_json }
        end
      end

    else
      respond_to do |format|
        format.js { render status: 404, json: "#{@document_templateable} id=#{@document_templateable.id} does not have a cabinet location set".to_json }
      end
    end

  rescue DocumentExists => error
    respond_to do |format|
      format.js { render status: 409, json: "Cannot import document: #{error.message}".to_json }
    end

  rescue IOError => error
    Rails.logger.error { "Cannot connect to legacy cabinet: #{error.message}" }
    respond_to do |format|
      format.js { render status: 451, json: "Cannot connect to legacy cabinet".to_json }
    end

  rescue Errno::ECONNREFUSED => error
    Rails.logger.error { "Cannot connect to document store: #{error.message}" }
    respond_to do |format|
      format.js { render status: 503, json: "Cannot connect to document store".to_json }
    end

  # rescue => error
  #   respond_to do |format|
  #     format.js { render status: 500, json: error }
  #   end
  end

  private
  def find_documentable
    documentable_type = fetch_file_params[:documentable_type].constantize
    documentable = documentable_type.find(fetch_file_params[:documentable_id])

    documentable
  end

  def fetch_file_params
    params.permit(:documentable_type, :documentable_id)
  end
end
