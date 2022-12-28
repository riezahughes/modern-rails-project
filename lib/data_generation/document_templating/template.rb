class DocumentTemplating::Template
  require "sablon"

  def self.create_templated_document_for_client_file(document_template, client_file, current_user)
    template = Sablon.template(document_template.template_file.path)
    context = DocumentTemplating::TemplateValues.client_file_template_context client_file, current_user

    template.render_to_string(context)
  end

  def self.create_templated_document_for_templateable(document_template, document_templateable, current_user)
    template = Sablon.template(document_template.template_file.path)
    context = DocumentTemplating::TemplateValues.template_context document_templateable, current_user

    template.render_to_string(context)
  end

end
