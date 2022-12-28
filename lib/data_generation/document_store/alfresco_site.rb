class AlfrescoSite

  def self.get_session_id
    uri = URI.parse(AlfrescoConfig[:login_uri])
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({'username' => AlfrescoConfig[:username], 'password' => AlfrescoConfig[:password]})
    request['Content-Type'] = 'application/x-www-form-urlencoded'

    response = Net::HTTP.new(uri.host, uri.port).request(request)
    response.get_fields('set-cookie').select{ |cookie_value| cookie_value =~ /JSESSIONID/ }.first.match('=([A-Z0-9]+)')[1]
  end

  def self.create_test_site
    session_id = get_session_id

    uri = URI.parse(AlfrescoConfig[:create_site_uri])
    request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
    request['Cookie'] = "JSESSIONID=#{session_id}"

    request.body = {
     visibility: "PUBLIC",
     title: "Test Site",
     shortName: "test",
     description: "Test Site",
     sitePreset: "site-dashboard",
     folders: [
       {
         name: "test_folder",
         title: "Test Folder"
       }
     ]
    }.to_json

    Net::HTTP.new(uri.host, uri.port).request(request)
  end

  def self.create_root_folder(site_name)
    server = CMIS::Server.new(service_url: AlfrescoConfig[:browser_uri], username: AlfrescoConfig[:username], password: AlfrescoConfig[:password])
    main_repository = server.repository AlfrescoConfig[:repository]

    sites_folder = main_repository.find_object('cmis:folder', 'cmis:name' => 'Sites')
    test_site_folder = main_repository.find_object('cmis:folder', 'cmis:name' => site_name, 'cmis:parentId' => sites_folder.cmis_object_id)

    Rails.logger.info "No test site found in: #{sites_folder.children.each_child.map(&:name).join(', ')}" unless test_site_folder

    document_library_folder = main_repository.find_object('cmis:folder', 'cmis:name' => 'documentLibrary', 'cmis:parentId' => test_site_folder.cmis_object_id)

    unless document_library_folder
      Rails.logger.info "No documentLibrary found in: #{test_site_folder.children.each_child.map(&:name).join(', ')}"

      begin
        document_library_folder = main_repository.new_folder
        document_library_folder.name = 'documentLibrary'
        document_library_folder.object_type_id = 'cmis:folder'
        document_library_folder = test_site_folder.create(document_library_folder)

        Rails.logger.info "documentLibrary folder created: #{document_library_folder.cmis_object_id}"
      rescue
        Rails.logger.error "Error: #{$!}"
      end
    end

    begin
      folder = main_repository.new_folder
      folder.name = 'root'
      folder.object_type_id = 'cmis:folder'
      folder = document_library_folder.create(folder)
      Rails.logger.info "Alfresco root folder created"
    rescue CMIS::Exceptions::ContentAlreadyExists
      folder = main_repository.find_object('cmis:folder', 'cmis:name' => 'root')
      Rails.logger.info "Alfresco root folder already created"
    end

    folder.cmis_object_id
  end

end
