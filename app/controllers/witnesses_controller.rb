class WitnessesController < AuthoritativeController

  before_action :set_client_file, only: [:index, :create_forms]
  before_action :set_document_template, only: [:create_forms]

  def multi_select_row
    @client_file_id = row_params[:client_file_id]
    @label = row_params[:label]

    respond_to :js
  end

  def index
    @witnesses = @client_file.witnesses

    respond_to :json
  end

  def create_forms
    @cited_witnesses = @client_file.witnesses.cited

    @file_forms = FileForms::CitedWitnesses.create_forms @client_file, @cited_witnesses
    @templated_documents = FileForms::CitedWitnesses.create_templated_documents_for_forms @file_forms, @document_template, @client_file

    respond_to :js
  end

  private
  def row_params
    params.permit(:client_file_id, :label)
  end

  def set_client_file
    @client_file = ClientFile.find_by_file_number(params[:id])
  end

  def set_witness
    @witness = Witness.find(params[:witness_id])
  end

  def set_document_template
    @document_template = DocumentTemplate.find(params[:document_template_id])
  end
end
