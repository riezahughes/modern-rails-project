module DocumentTemplateableActions
  extend ActiveSupport::Concern

  included do
    before_action :set_document_templateable, only: [:download]
  end

  def download
    pdf_file = @document_templateable.pdf_preview

    respond_to do |format|
      format.pdf { send_data pdf_file,
                    file_name: 'pdf_preview.pdf',
                    type: 'application/pdf',
                    disposition: 'inline',
                    stream: 'true',
                    buffer_size: '4096' }
    end

    rescue
      respond_to do |format|
        format.pdf { send_data File.read(Rails.root.join('public/preview_not_available.pdf')),
                      file_name: 'pdf_preview.pdf',
                      type: 'application/pdf',
                      disposition: 'inline',
                      stream: 'true',
                      buffer_size: '4096' }
      end
  end
end
