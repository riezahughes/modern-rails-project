module AlfrescoClientFile

  include AlfrescoFolder

  def create_file_folder(repository, name, description, client, attributes = {})
    unless repository
      return nil
    end

    # root_folder_id = attributes[:app_root_folder_id] || AlfrescoConfig[:app_root_folder_id]
    root_folder_id = client_folder_id client
    subfolder_names = attributes[:file_subfolders_to_be_created] || AlfrescoConfig[:file_subfolders_to_be_created]
    parent_folder = repository.object root_folder_id

    create_alfresco_folder(repository, name, description, parent_folder, subfolder_names)
  end

  def client_folder_id(client)

    begin
      client_folder = client.get_alfresco_folder
    rescue ObjectNotFound
      client_folder = client.create_folder
    end

    file_folder = client_folder.child_by_name AlfrescoConfig[:client_file_folder]
    file_folder.id

  end

end