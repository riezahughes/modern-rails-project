module AlfrescoFolder

  def create_alfresco_folder(repository, name, description, parent_folder, subfolder_names = nil)
    begin
      unless parent_folder
        Rails.logger.error "Cannot create folder #{name}, no parent folder given"
        return nil
      end

      Rails.logger.info "Creating folder #{name} in #{parent_folder.name} (#{parent_folder.cmis_object_id})"
      folder = create_folder_object(repository, name, description)
      folder = parent_folder.create(folder)

      if subfolder_names
        subfolder_names.each do |subfolder_name|
          begin
            Rails.logger.info "Creating folder #{subfolder_name} in #{name} (#{folder.cmis_object_id})"
            subfolder = create_folder_object(repository, subfolder_name)
            folder.create(subfolder)
          rescue CMIS::Exceptions::ContentAlreadyExists => e
            Rails.logger.warn "Sub folder #{name} already exists"
          end
        end
      end
      folder
    rescue CMIS::Exceptions::ContentAlreadyExists => e
      Rails.logger.warn "#{name} already exists"
      raise FolderExists.new "#{name} already exists"
    end
  end

  private
  def create_folder_object(repository, name, description = '')
    folder = repository.new_folder
    folder.name = name
    folder.object_type_id = 'cmis:folder'
    unless description.blank?
      folder.description = description
    end
    folder
  end
end
