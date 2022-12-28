module DocumentStoreFolderActions
  extend ActiveSupport::Concern

  included do
    before_action :set_folder_owner, only: [:folder_contents, :create_folder, :folder_link]
  end

  def folder_contents
    if @folder_owner.alfresco_integrated?
      begin
        folder = @folder_owner.get_alfresco_folder

        if folder
          @folder ||= folder
          render json: folder.to_json
        else
          render json: {message: "Unable to connect to document store"}, status: :service_unavailable
        end
      rescue ObjectNotFound
        render json: {message: "Folder for #{self.class.name.gsub(/Controller/, '').singularize} not found"}, status: :not_found
      end
    else
      render json: {message: "Alfresco integration is off"}, status: :service_unavailable
    end
  end

  def folder_link
    if @folder_owner.alfresco_integrated?
      begin
        @folder ||= @folder_owner.get_alfresco_folder
        if @folder
          render '_folder_link_button', locals: {folder_url: @folder_owner.get_object_site_url(@folder.node_ref)}, layout: false
        else
          render '_folder_link_button', locals: {folder_url: @folder_owner.get_object_site_url(nil)}, layout: false
        end
      rescue ObjectNotFound
        render json: {message: "Folder for #{self.class.name.gsub(/Controller/, '').singularize} not found"}, status: :not_found
      end
    else
      render json: {message: "Alfresco integration is off"}, status: :service_unavailable
    end
  end

  def create_folder
    if @folder_owner.alfresco_integrated?
      begin
        folder = @folder_owner.create_folder

        if folder
          redirect_to @folder_owner, notice: 'Folder successfully created in the document store.'
        else
          redirect_to @folder_owner
        end
      rescue FolderExists
        redirect_to @folder_owner, alert: 'Folder already exists.'
      end
    else
      render json: {message: "Alfresco integration is off"}, status: :service_unavailable
    end
  end
end