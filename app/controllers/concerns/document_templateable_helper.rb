module DocumentTemplateableHelper
  extend ActiveSupport::Concern

  included do
    before_action :set_templated_document_id, only: [:new, :edit, :create, :update]
    before_action :set_document_template_id, only: [:new, :edit, :create, :update]
    before_action :set_open_for_edit, only: [:create]

    def document_template_params
      params.permit(:templated_document_id, :document_template_id)
    end

    def set_templated_document_id
      if document_template_params[:templated_document_id]
        @templated_document_id = params[:templated_document_id]
        @templated_document = TemplatedDocument.find_by_id(@templated_document_id)
      end
    end

    def set_document_template_id
      if document_template_params[:document_template_id]
        @document_template_id = params[:document_template_id]
        @document_template = DocumentTemplate.find_by_id(@document_template_id)
      end
    end

    def set_open_for_edit
      @open_for_edit = false
    end

    def save_templated_document_to_templateable(document_templateable)
      @templated_document.update!(document_templateable: document_templateable) if @templated_document
    end

    def set_word_count(document_templateable)
      document_templateable.update!(length: AlfrescoWordCount.templated_document_word_count(@templated_document)) if @templated_document
    end

  end

end
