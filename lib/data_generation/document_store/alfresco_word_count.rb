class AlfrescoWordCount

  def self.templated_document_word_count(templated_document)
    name = AlfrescoLocalDownload.download_document_locally(templated_document)
    word_count = WordCount.count_docx(name)
    File.delete(name)

    word_count

  rescue => error
    Rails.logger.error { error }
    File.delete(name)
    0
  end

end
