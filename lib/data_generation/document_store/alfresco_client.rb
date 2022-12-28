module AlfrescoClient

  include AlfrescoFolder

  def create_client_folder(repository, name, description)
    unless repository
      return nil
    end

    root_folder_id = AlfrescoConfig[:app_root_folder_id]
    subfolder_names = AlfrescoConfig[:client_subfolders_to_be_created]
    parent_folder = repository.object root_folder_id

    create_alfresco_folder(repository, name, description, parent_folder, subfolder_names)
  end

end
