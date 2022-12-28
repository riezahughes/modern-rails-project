require 'ostruct'
require 'yaml'

file = ERB.new(File.read(Rails.root.join('config', 'alfresco.yml'))).result

all_config = YAML.load(file, aliases: true) || {}
env_config = all_config[Rails.env] || {}

AlfrescoConfig = OpenStruct.new(env_config)

if AlfrescoConfig[:app_root_folder_id]
  Rails.logger.info "Using alfresco root folder id #{AlfrescoConfig[:app_root_folder_id]}"
else
  if Rails.env.development?
    begin
      AlfrescoSite.create_test_site
      AlfrescoConfig[:app_root_folder_id] = AlfrescoSite.create_root_folder('test')

    rescue
      p 'Unable to connect to Alfresco to create a test site'
      Rails.logger.error { 'Unable to connect to Alfresco to create a test site' }
    end
  end
end
