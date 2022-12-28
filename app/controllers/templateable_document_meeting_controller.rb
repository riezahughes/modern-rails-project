class TemplateableDocumentMeetingController < ApplicationController
  include WorkControllerHelper

  before_action :set_document_template
  before_action :set_client_file

  def new_meeting_templateable_document

    meeting = Meeting.new(meeting_params)
    meeting.client_file = @client_file
    add_new_work meeting

    template_type = templateable_document_params[:template_type]

    templated_document = AlfrescoTemplatedDocument.create_templated_document(@client_file, @document_template, current_user, meeting)
    templated_document_path = AlfrescoTemplatedDocument.document_path templated_document

    @templated_document = TemplatedDocument.create!(alfresco_id: templated_document.cmis_object_id,
                                                      document_path: templated_document_path,
                                                      document_template: @document_template)

    respond_to do |format|
      format.js { render 'meetings/_attendance_note_created', status: :created }
    end

  rescue DocumentTemplatingError => e
    Rails.logger.error e
    redirect_to @client_file, alert: "Error: #{e}"
  end

  def new_precognition_templateable_document

    meeting = Meeting.new(meeting_params)
    meeting.client_file = @client_file
    add_new_work meeting

    precognition = Precognition.new(meeting: meeting)

    template_type = templateable_document_params[:template_type]

    templated_document = AlfrescoTemplatedDocument.create_templated_document(@client_file, @document_template, current_user, precognition)
    templated_document_path = AlfrescoTemplatedDocument.document_path templated_document

    @templated_document = TemplatedDocument.create!(alfresco_id: templated_document.cmis_object_id,
                                                      document_path: templated_document_path,
                                                      document_template: @document_template)

    respond_to do |format|
      format.js { render 'meetings/_precognition_document_created', status: :created }
    end

  rescue DocumentTemplatingError => e
    Rails.logger.error e
    redirect_to @client_file, alert: "Error: #{e}"
  end

  private
  def templateable_document_params
    params.permit(:document_template_id, :client_file_id, :template_type)
  end

  def meeting_params
    params.require(:meeting).permit(:locus,
                                    :attendance_with,
                                    :meeting_type_id,
                                    :witness_id)
  end

  def meeting_template_params
    params.permit(:meeting_document_template_id, :meeting_templated_document_id)
  end

  def set_document_template
    @document_template = DocumentTemplate.find(templateable_document_params[:document_template_id])
  end

  def set_client_file
    @client_file = ClientFile.find(templateable_document_params[:client_file_id])
  end

end
