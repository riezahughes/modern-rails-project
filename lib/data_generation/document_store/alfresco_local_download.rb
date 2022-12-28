class AlfrescoLocalDownload

  def self.download_document_locally(templated_document)

    session_id = AlfrescoSite.get_session_id
    url = document_original_url(templated_document)

    Rails.logger.debug { url }

    open(templated_document.file_name, 'wb') do |file|
      file << open(url, 'Cookie' => "JSESSIONID=#{session_id}").read
    end

    templated_document.file_name
  end

  def self.document_original_url(templated_document)
    "#{AlfrescoConfig[:space_store_uri]}/#{templated_document.alfresco_id.gsub(/;\d+\.\d+$/, '')}/#{templated_document.file_name}"
  end

end
