class TemplateableDocumentController < ApplicationController
  include WorkControllerHelper

  # before_action :set_document_template
  before_action :set_client_file

  def new_templateable_document
    unless templateable_document_params[:document_template_id].blank?
      @document_template = DocumentTemplate.find(templateable_document_params[:document_template_id])

      template_type = templateable_document_params[:template_type]

      templated_document = AlfrescoTemplatedDocument.create_templated_document(@client_file, @document_template, current_user)
      templated_document_path = AlfrescoTemplatedDocument.document_path templated_document

      @templated_document = TemplatedDocument.create!(alfresco_id: templated_document.cmis_object_id,
                                                        document_path: templated_document_path,
                                                        document_template: @document_template)

      redirect_to new_polymorphic_path(template_type.constantize.new,
        client_file_id: @client_file.id,
        parent_type: 'ClientFile',
        document_template_id: @document_template.id,
        templated_document_id: @templated_document.id)

    else
      redirect_to @client_file, alert: "Please specify a document template"
    end

  rescue DocumentTemplatingError => e
    Rails.logger.error e
    redirect_to @client_file, alert: "Error: #{e}"
  end

  def new_form_templateable_document
    unless templateable_document_params[:document_template_id].blank?
      @document_template = DocumentTemplate.find(templateable_document_params[:document_template_id])

      template_type = templateable_document_params[:template_type]
      witness_id = templateable_document_params[:witness_id]
      temp_file_form = FileForm.new(client_file: @client_file, witness_id: witness_id)

      templated_document = AlfrescoTemplatedDocument.create_templated_document(@client_file,
                                                                              @document_template,
                                                                              current_user,
                                                                              temp_file_form)
      templated_document_path = AlfrescoTemplatedDocument.document_path templated_document

      @templated_document = TemplatedDocument.create!(alfresco_id: templated_document.cmis_object_id,
                                                        document_path: templated_document_path,
                                                        document_template: @document_template)

      redirect_to new_polymorphic_path(template_type.constantize.new,
        client_file_id: @client_file.id,
        parent_type: 'ClientFile',
        witness_id: witness_id,
        document_template_id: @document_template.id,
        templated_document_id: @templated_document.id)

    else
      redirect_to @client_file, alert: "Please specify a document template"
    end

  rescue DocumentTemplatingError => e
    Rails.logger.error e
    redirect_to @client_file, alert: "Error: #{e}"
  end

  private
  def templateable_document_params
    params.permit(:document_template_id, :client_file_id, :template_type, :witness_id)
  end

  def set_client_file
    @client_file = ClientFile.find(templateable_document_params[:client_file_id])
  end

end
