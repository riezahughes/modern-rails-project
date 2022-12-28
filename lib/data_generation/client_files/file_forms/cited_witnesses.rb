class FileForms::CitedWitnesses

  def self.create_forms(client_file, cited_witnesses)
    cited_witnesses.map do |cited_witness|
      description = "Witness citation for #{cited_witness.to_s}"

      FileForm.create!(client_file: client_file,
                        witness: cited_witness,
                        form_date: DateTime.now,
                        description: description)
    end
  end

  def self.create_templated_documents_for_forms(file_forms, document_template, client_file)

    file_forms.map do |file_form|

      templated_document = AlfrescoTemplatedDocument.create_templated_document(client_file, document_template, file_form)
      templated_document_path = AlfrescoTemplatedDocument.document_path templated_document

      templated_document = TemplatedDocument.create!(alfresco_id: templated_document.cmis_object_id,
                                                        document_path: templated_document_path,
                                                        document_template: document_template,
                                                        document_templateable: file_form)
      templated_document
    end

  end

end
