module AlfrescoConnection

  def alfresco_integrated?
    AlfrescoConfig[:alfresco_integration]
  end

  def connect_to_alfresco(attributes = nil)
    attributes ||= {}
    unless @repository
      @service_url = attributes[:service_url] || AlfrescoConfig[:browser_uri]
      @username = attributes[:username] || AlfrescoConfig[:username]
      @password = attributes[:password] || AlfrescoConfig[:password]
      @repository_name = attributes[:repository] || AlfrescoConfig[:repository]

      begin
        @server = attributes[:server] || CMIS::Server.new(service_url: @service_url, username: @username, password: @password)
        @repository = @server.repository @repository_name
        @repository
      rescue
        nil
      end
    end
  end

  def get_alfresco_id(name)
    @alfresco_id ||= alfresco_id
    unless @alfresco_id
      @alfresco_id ||= get_id_for_name(name)
      self.update(alfresco_id: @alfresco_id)
    end
    @alfresco_id
  end

  def get_repository(attributes = {})
    connect_to_alfresco attributes
    @repository
  end

  def get_object_site_url(node_ref, attributes = {})
    connect_to_alfresco attributes
    unless @repository
      return nil
    end

    begin
      uri = URI.parse("#{AlfrescoConfig[:site_share_uri]}?nodeRef=#{node_ref}")
      req = Net::HTTP::Get.new(uri)
      req.basic_auth @username, @password

      response = Net::HTTP.start(uri.hostname, uri.port) { |http|
        http.request(req)
      }

      JSON.parse(response.body)['url']
    rescue
      nil
    end
  end

  def get_object_by_id(id, attributes = {})
    connect_to_alfresco attributes
    unless @repository
      return nil
    end

    begin
      @repository.object id
    rescue CMIS::Exceptions::ObjectNotFound => e
      raise ObjectNotFound.new e.to_s
    end
  end

  def get_id_for_name(folder_name, attributes = {})
    connect_to_alfresco attributes
    unless @repository
      return nil
    end

    item = @repository.find_object('cmis:folder', 'cmis:name' => folder_name)
    unless item
      return nil
    end

    item.cmis_object_id
  end
end
