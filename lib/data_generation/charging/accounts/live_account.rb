class LiveAccount

  def self.for_client_file(client_file)
    client_file.accounts.not_feed.order(effective_from: :desc).first
  end

end
