module DisclosureUploadActions
  extend ActiveSupport::Concern

  included do
    before_action :set_disclosure_owner, only: [:upload_disclosure]
  end

  def upload_disclosure
    @uploaded = []
    if params[:client_file] && params[:client_file][:pdf_documents]
      params[:client_file][:pdf_documents].each do |pdf_document|
        @uploaded << @disclosure_owner.disclosures.create(pdf_document: pdf_document)
      end
    end

    respond_to do |format|

      begin
        containing_folder = @disclosure_owner.get_alfresco_folder
        if containing_folder.nil?
          flash.now[:alert] = 'Unable to connect to document store, the documents will not be saved'
        end
      rescue ObjectNotFound
        flash.now[:notice] = 'A new folder will be created for the disclosure documents'
      end
      
      format.html {}
    end
  end

  def upload_to_document_store
    @disclosures = []
    @errors = {}
    upload_to_document_store_params.each do |id, numbering_params|
      disclosure = Disclosure.update(id, numbering_params.permit(:number_pages, :skip_pages, :skip_odd, :skip_even))
      if disclosure.valid?
        unless disclosure.last_page
          disclosure.do_numbering
        end

        disclosure.create_document
      end
      @disclosures << disclosure
    end

    respond_to do |format|
      if @disclosures.all? { |disclosure| disclosure.valid? && disclosure.document_errors.blank? }
        format.js { render :upload_disclosure_results }
      else
        @errors = errors_hash(@disclosures)
        format.js { render :upload_disclosure_results, status: :unprocessable_entity }
      end
    end
  end

  private
  def errors_hash(disclosures)
    disclosures.reduce({}) { |a, disclosure|
      a[disclosure.id] = {}
      a[disclosure.id].merge! disclosure.errors unless disclosure.valid?
      a[disclosure.id].merge!({document_errors: disclosure.document_errors}) unless disclosure.document_errors.blank?
      a
    }
  end

  private
  def upload_to_document_store_params
    if params[:disclosure]
      permit_key_params(params[:disclosure]) do
        params.require(:disclosure)
      end
    else
      {}
    end
  end

  def permit_key_params(hash)
    permitted_params = yield
    hash.keys.each do |key|
      values = hash.delete(key)
      permitted_params[key] = values if values
    end
    permitted_params
  end

end