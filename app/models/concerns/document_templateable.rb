module DocumentTemplateable
  extend ActiveSupport::Concern

  def self.classes
    Rails.application.eager_load!
    ActiveRecord::Base.descendants
        .select { |c| c.included_modules.include?(DocumentTemplateable) }
  end

  included do
    belongs_to :document_template

    has_one :templated_document, as: :document_templateable

    def import_templated_document(contents, file_name)
      AlfrescoTemplatedDocument.import_existing_document(client_file, contents, file_name, self.class.name)
    end

    def to_template_values
      {}
    end

    def pdf_preview
      raise ActionController::RoutingError.new("Missing PDF preview for #{self.to_s}") if templated_document.nil?

      session_id = AlfrescoSite.get_session_id
      open(templated_document.document_pdf_perview_url, 'Cookie' => "JSESSIONID=#{session_id}").read

    rescue => error
        Rails.logger.error { "Unable to get preview for url #{templated_document.document_pdf_perview_url} : #{error}" }
        nil
    end

    def document_present?
      !templated_document.nil?
    end

    private
    def file_manually_changed?
      ["templated_document_file_size",
       "templated_document_updated_at",
       "templated_document_file_name"].all? { |i| self.changed.include?(i) }
    end

  end

end
