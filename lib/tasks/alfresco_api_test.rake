namespace :alfresco do

  require 'net/http'
  require 'cmis'

  desc "Create a folder for each file in the alfresco application"
  task :create_folders => :environment do

    server = CMIS::Server.new(service_url: AlfrescoConfig[:browser_uri], username: AlfrescoConfig[:username], password: AlfrescoConfig[:password])
    main_repository = server.repository AlfrescoConfig[:repository]
    file_folder = main_repository.object AlfrescoConfig[:app_root_folder_id]

    ClientFile.all.each do |file|

      begin
        folder = main_repository.new_folder
        folder.name = file.file_number
        folder.object_type_id = 'cmis:folder'
        folder.description = "#{file.client.full_name} #{file.subject_matter}"
        folder = file_folder.create(folder)

        puts "#{file.file_number} created"
      rescue
        puts "Error #{$!}"
      end

    end


  end

  desc "List available folders in the root folder of the repository"
  task :read_folders => :environment do
    server = CMIS::Server.new(service_url: AlfrescoConfig[:browser_uri], username: AlfrescoConfig[:username], password: AlfrescoConfig[:password])
    main_repository = server.repository AlfrescoConfig[:repository]

    file_folder = main_repository.object AlfrescoConfig[:app_root_folder_id]
    file_folder.children.each_child do |child|

      uri = URI.parse("#{AlfrescoConfig[:site_share_uri]}?nodeRef=#{child.properties['alfcmis:nodeRef']}")
      req = Net::HTTP::Get.new(uri)
      req.basic_auth AlfrescoConfig[:username], AlfrescoConfig[:password]

      response = Net::HTTP.start(uri.hostname, uri.port) { |http|
        http.request(req)
      }

      puts "#{child.name} #{child.cmis_object_id} #{JSON.parse(response.body)['url']}"
    end

    # doc_folder = main_repository.find_object 'cmis:folder', 'cmis:name' => 'V9179'
    # puts doc_folder.methods


  end

  desc "Folder Id by name"
  task :read_folder_id, [:name] => [:environment] do |t, args|
    server = CMIS::Server.new(service_url: AlfrescoConfig[:browser_uri], username: AlfrescoConfig[:username], password: AlfrescoConfig[:password])
    main_repository = server.repository AlfrescoConfig[:repository]
    folder = main_repository.find_object('cmis:folder', 'cmis:name' => "#{args[:name]}")
    puts folder.cmis_object_id
  end

  desc "Create site"
  task :create_site => [:environment] do
    uri = URI.parse(AlfrescoConfig[:login_uri])
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({'username' => AlfrescoConfig[:username], 'password' => AlfrescoConfig[:password]})
    request['Content-Type'] = 'application/x-www-form-urlencoded'

    response = Net::HTTP.new(uri.host, uri.port).request(request)
    session_id = response.get_fields('set-cookie').select{ |cookie_value| cookie_value =~ /JSESSIONID/ }.first.match('=([A-Z0-9]+)')[1]

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

    response = Net::HTTP.new(uri.host, uri.port).request(request)
    p JSON.parse response.read_body

    server = CMIS::Server.new(service_url: AlfrescoConfig[:browser_uri], username: AlfrescoConfig[:username], password: AlfrescoConfig[:password])
    main_repository = server.repository AlfrescoConfig[:repository]

    sites_folder = main_repository.find_object('cmis:folder', 'cmis:name' => 'Sites')
    test_site_folder = main_repository.find_object('cmis:folder', 'cmis:name' => 'test', 'cmis:parentId' => sites_folder.cmis_object_id)

    puts "No test site found in: #{sites_folder.children.each_child.map(&:name).join(', ')}" unless test_site_folder

    document_library_folder = main_repository.find_object('cmis:folder', 'cmis:name' => 'documentLibrary', 'cmis:parentId' => test_site_folder.cmis_object_id)

    unless document_library_folder
      puts "No documentLibrary found in: #{test_site_folder.children.each_child.map(&:name).join(', ')}"

      begin
        document_library_folder = main_repository.new_folder
        document_library_folder.name = 'documentLibrary'
        document_library_folder.object_type_id = 'cmis:folder'
        document_library_folder = test_site_folder.create(document_library_folder)

        puts "documentLibrary folder created: #{document_library_folder.cmis_object_id}"
      rescue
        puts "Error: #{$!}"
      end
    end

    begin
      folder = main_repository.new_folder
      folder.name = 'root'
      folder.object_type_id = 'cmis:folder'
      folder = document_library_folder.create(folder)

      puts "Root folder created"
      puts folder.cmis_object_id
    rescue
      puts "Error: #{$!}"
    end

  end

  desc "Upload disclosure document by disclosure id"
  task :upload_disclosure, [:id] => [:environment] do |t, args|
    disclosure = Disclosure.find(args[:id])

    if disclosure
      document_object = disclosure.create_document
      if document_object.nil?
        puts "Unable to create document"
      else
        puts "Created #{document_object.name} with node id #{document_object.id}"
      end
    else
      puts "Disclosure with id #{args[:id]} not found"
    end

  end

end
