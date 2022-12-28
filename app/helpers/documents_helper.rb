module DocumentsHelper
  def default_documentable_id(exiting_document, documentable_type)
    return exiting_document.documentable.id if exiting_document.documentable

    return params["#{documentable_type.name.underscore}_id"] if documentable_type

    nil
  end

  def default_documentable(exiting_document, documentable_type)
    return exiting_document.documentable if exiting_document.documentable

    if documentable_type
      documentable_id_from_params = default_documentable_id(exiting_document, documentable_type)
      return documentable_type.find_by_id(documentable_id_from_params)
    end

    nil
  end
end
