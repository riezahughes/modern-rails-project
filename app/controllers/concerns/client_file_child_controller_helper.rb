module ClientFileChildControllerHelper
  extend ActiveSupport::Concern

  included do
    before_action :set_client_file, only: [:new, :edit, :create, :update]

    def set_client_file
      if params[:client_file_id]
        @client_file_id = params[:client_file_id]
        @client_file = ClientFile.find_by_id(@client_file_id)
      end
    end
  end

end
