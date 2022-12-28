module DocumentStoreDocumentActions
  extend ActiveSupport::Concern

  included do
    before_action :set_document_owner, only: [:document_link]
  end

  def document_link
    if @document_owner.alfresco_integrated?
      begin
        @document ||= @document_owner.get_alfresco_document
        if @document
          render '_document_link_button', locals: {document_url: @document_owner.get_object_site_url(@document.node_ref)}, layout: false
        else
          render '_document_link_button', locals: {document_url: @document_owner.get_object_site_url(nil)}, layout: false
        end
      rescue ObjectNotFound
        render json: {message: "Document for #{self.class.name.gsub(/Controller/, '').singularize} not found"}, status: :not_found
      end
    else
      render json: {message: "Alfresco integration is off"}, status: :service_unavailable
    end
  end
end